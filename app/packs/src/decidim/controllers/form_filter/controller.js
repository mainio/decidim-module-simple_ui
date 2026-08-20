/* eslint-disable no-div-regex, no-useless-escape, no-param-reassign, id-length */
/* eslint max-lines: ["error", {"max": 410, "skipBlankLines": true}] */

import { Controller } from "@hotwired/stimulus"
import delayed from "src/decidim/refactor/moved/delayed"
import CheckBoxesTree from "src/decidim/refactor/moved/check_boxes_tree"
import { registerCallback, unregisterCallback, pushState, replaceState, state } from "src/decidim/refactor/moved/history"

/**
 * A Stimulus controller that handles the form filter.
 * @class
 * @augments Controller
 */
export default class extends Controller {
  connect() {
    this.id = this.element.id || this._getUID();
    this.mounted = false;
    this.changeEvents = true;
    this.theCheckBoxesTree = new CheckBoxesTree();
    this.queue = 0;

    this._updateInitialState();
    this._onFormChange = delayed(this, this._onFormChange.bind(this));
    this._onPopState = this._onPopState.bind(this);
    this._onAjaxSuccess = this._onAjaxSuccess.bind(this);
    this._onAjaxError = this._onAjaxError.bind(this);
    this._onResetClick = this._onResetClick.bind(this);
    this._onFilterKeydown = this._onFilterKeydown.bind(this);

    if (window.Decidim.PopStateHandler) {
      this.popStateSubmitter = false;
    } else {
      this.popStateSubmitter = true;
      window.Decidim.PopStateHandler = this.id;
    }

    this.mountComponent()
  }

  /**
   * Handles the logic for unmounting the component
   * @public
   * @returns {Void} - Returns nothing
   */
  disconnect() {
    this.element.querySelectorAll("input, select").forEach((element) => {
      element.removeEventListener("change", this._onFormChange);
    });

    this.element.removeEventListener("keydown", this._onFilterKeydown);

    document.removeEventListener("click", this._onResetClick);

    unregisterCallback(`filters-${this.id}`)

    document.removeEventListener("ajax:success", this._onAjaxSuccess);
    document.removeEventListener("ajax:error", this._onAjaxError);
  }

  /**
   * Handles the logic for mounting the component
   * @public
   * @returns {Void} - Returns nothing
   */
  mountComponent() {
    if (this.mounted) {
      return;
    }
    this.mounted = true;

    if (window.performance?.getEntriesByType("navigation")[0]?.type === "back_forward") {
      const savedFiltersJSON = sessionStorage.getItem("filteredParams");
      if (savedFiltersJSON) {
        const savedFilters = JSON.parse(savedFiltersJSON);
        const savedPath = savedFilters[this.element.action];

        if (savedPath) {
          const originalGetLocation = this._getLocation;
          this._getLocation = () => savedPath;

          this._onPopState();

          this._getLocation = originalGetLocation;
        }
      }
    }

    document.addEventListener("click", this._onResetClick);

    this.element.addEventListener("keydown", this._onFilterKeydown);

    this.contentContainer = document.querySelector("main");
    if (!this.contentContainer && this.element.dataset.remoteFill) {
      this.contentContainer = document.querySelector(this.element.dataset.remoteFill);
    }

    this.element.querySelectorAll("input:not([data-disable-dynamic-change]), select:not([data-disable-dynamic-change])").forEach((element) => {
      element.addEventListener("change", this._onFormChange);
    })

    this.currentFormRequest = null;

    this.element.addEventListener("ajax:beforeSend", (e) => {
      if (this.currentFormRequest) {
        this.currentFormRequest.abort();
      }
      this.currentFormRequest = e.detail[0];
      this.queue += 1;
      if (this.queue > 0 && this.contentContainer && !this.contentContainer.classList.contains("spinner-container")) {
        this.contentContainer.classList.add("spinner-container");
      }
    })

    document.addEventListener("ajax:success", this._onAjaxSuccess);
    document.addEventListener("ajax:error", this._onAjaxError);

    this.theCheckBoxesTree.setContainerForm(this.element);

    registerCallback(`filters-${this.id}`, (currentState) => {
      this._onPopState(currentState);
    })
  }

  /**
   * Handles keydown events
   * @private
   * @param {Event} e - The keydown event
   * @returns {Void} - Returns nothing
   */
  _onFilterKeydown(e) {
    if (!e.target.matches('input[type="search"], input[type="checkbox"], input[type="radio"]')) {
      return;
    }

    const inputs = [...this.element.querySelectorAll('input[type="radio"][name="filter[with_date]"]')];
    const processDateMenu = document.getElementById("panel-dropdown-menu-process-date");
    const dateFilterTrigger = document.getElementById("trigger-menu-process-date");
    const caret = dateFilterTrigger
      ? dateFilterTrigger.querySelector("svg")
      : null;
    const currentIndex = inputs.indexOf(e.target);

    switch (e.key) {
    case "Enter":
      e.preventDefault();
      Rails.fire(this.element, "submit");
      break;
    case "ArrowDown":
      e.preventDefault();
      if (inputs.length) {
        const nextIndex = currentIndex === -1 || currentIndex === inputs.length - 1
          ? 0
          : currentIndex + 1;
        inputs[nextIndex].focus();
      }
      break;
    case "ArrowUp":
      e.preventDefault();
      if (inputs.length) {
        const prevIndex = currentIndex <= 0
          ? inputs.length - 1
          : currentIndex - 1;
        inputs[prevIndex].focus();
      }
      break;
    case "Escape":
      e.preventDefault();
      if (processDateMenu && !processDateMenu.classList.contains("hidden")) {
        processDateMenu.classList.add("hidden");
        caret?.classList.remove("rotate-180");
        dateFilterTrigger.focus();
      }
      break;
    default:
      break;
    }
  }

  /**
   * Handles ajax:success event
   * @private
   * @returns {Void} - Returns nothing
   */
  _onAjaxSuccess() {
    const [currentPath] = this._currentStateAndPath();
    this._saveFilters(currentPath);

    this.queue -= 1;
    if (this.queue <= 0 && this.contentContainer) {
      this.contentContainer.classList.remove("spinner-container");
    }
  }

  /**
   * Handles ajax:error event
   * @private
   * @returns {Void} - Returns nothing
   */
  _onAjaxError() {
    this.queue -= 1;
    if (this.queue <= 0 && this.contentContainer) {
      this.contentContainer.classList.remove("spinner-container");
      this.contentContainer.classList.add("hide");
    }
  }

  /**
   * Handles the reset-filters click
   * @private
   * @param {Event} e - The click event
   * @returns {Void} - Returns nothing
   */
  _onResetClick(e) {
    if (!e.target.closest("#reset-filters")) {
      return;
    }
    this._clearForm();
  }

  /**
   * Sets path in the browser history with the initial filters state, to allow to restoring it when using browser history.
   * @private
   * @returns {Void} - Returns nothing.
   */
  _updateInitialState() {
    const [initialPath, initialState] = this._currentStateAndPath();
    initialState._path = initialPath
    replaceState(null, initialState);
  }

  /**
   * Finds the current location.
   * @param {boolean} withHost - include the host part in the returned location
   * @private
   * @returns {String} - Returns the current location.
   */
  _getLocation(withHost = true) {
    const currentState = state();
    let path = "";

    if (currentState && currentState._path) {
      path = currentState._path;
    } else {
      path = window.location.pathname + window.location.search + window.location.hash;
    }

    if (withHost) {
      return window.location.origin + path;
    }
    return path;
  }

  /**
   * Parse current location and get filter values.
   * @private
   * @returns {Object} - An object where a key correspond to a filter field
   *                     and the value is the current value for the filter.
   */
  _parseLocationFilterValues() {
    // Every location param is constructed like this: filter[key]=value
    let regexpResult = decodeURIComponent(this._getLocation()).match(/filter\[([^\]]*)\](?:\[\])?=([^&]*)/g);

    // The RegExp g flag returns null or an array of coincidences. It does not return the match groups
    if (regexpResult) {
      const filterParams = regexpResult.reduce((acc, result) => {
        const [, key, array, value] = result.match(/filter\[([^\]]*)\](\[\])?=([^&]*)/);
        if (array) {
          if (!acc[key]) {
            acc[key] = [];
          }
          acc[key].push(value);
        } else {
          acc[key] = value;
        }
        return acc;
      }, {});

      return filterParams;
    }

    return null;
  }

  /**
   * Parse current location and get the current order.
   * @private
   * @returns {string} - The current order
   */
  _parseLocationOrderValue() {
    const url = this._getLocation();
    const match = url.match(/order=([^&]*)/);
    const orderMenu = this.element.querySelector(".order-by .menu");
    let order = null;

    if (orderMenu) {
      order = orderMenu.querySelector(".menu a").dataset.order;

      if (match) {
        order = match[1];
      }
    }

    return order;
  }

  /**
   * Clears the form to start with a clean state.
   * @private
   * @returns {Void} - Returns nothing.
   */
  _clearForm() {
    this.element.querySelectorAll("input[type=checkbox]").forEach((element) => {
      element.checked = element.indeterminate = false;
    });
    this.element.querySelectorAll("input[type=radio]").forEach((element) => {
      element.checked = false;
    })
    const radio = this.element.querySelector("fieldset input[type=radio]");
    if (radio) {
      radio.checked = true;
    }

    const searchInput = this.element.querySelector("input[type=search]");
    if (searchInput) {
      searchInput.value = "";
    }
  }

  /**
   * Handles the logic when going back to a previous state in the filter form.
   * @private
   * @returns {Void} - Returns nothing.
   */
  _onPopState() {
    this.changeEvents = false;
    this._clearForm();

    // Prevent filtering again on anchor link "Skip to main content", "Skip map", or "Skip to results"
    const filterSkipValues = [...document.querySelectorAll("[data-skip-to-content]")].map((el) => el.hash);
    if (filterSkipValues.includes(window.location.hash)) {
      return;
    }

    const filterParams = this._parseLocationFilterValues();
    const currentOrder = this._parseLocationOrderValue();

    const orderFilter = this.element.querySelector("input.order_filter");
    if (orderFilter) {
      orderFilter.value = currentOrder;
    }

    if (filterParams) {
      const fieldIds = Object.keys(filterParams);

      // Iterate the filter params and set the correct form values
      fieldIds.forEach((fieldName) => {
        let value = filterParams[fieldName];

        if (Array.isArray(value)) {
          let checkboxes = this.element.querySelectorAll(`input[type=checkbox][name="filter[${fieldName}][]"]`);
          this.theCheckBoxesTree.updateChecked(checkboxes, value);
        } else {
          this.element.querySelectorAll(`*[name="filter[${fieldName}]"]`).forEach((element) => {
            switch (element.type) {
            case "hidden":
              break;
            case "radio":
            case "checkbox":
              element.checked = value === element.value;
              break;
            default:
              element.value = value;
            }
          });
        }
      });
    }

    // Only one instance should submit the form on browser history navigation
    if (this.popStateSubmitter) {
      Rails.fire(this.element, "submit");
    }

    this.changeEvents = true;
  }

  /**
   * Handles the logic to update the current location after a form change event.
   * @private
   * @returns {Void} - Returns nothing.
   */
  _onFormChange() {
    if (!this.changeEvents) {
      return;
    }

    const [newPath, newState] = this._currentStateAndPath();
    const path = this._getLocation(false);

    if (newPath === path) {
      return;
    }

    Rails.fire(this.element, "submit");
    pushState(newPath, newState);
    this._saveFilters(newPath);
  }

  /**
   * Calculates the path and the state associated to the filters inputs.
   * @private
   * @returns {Array} - Returns an array with the path and the state for the current filters state.
   */
  _currentStateAndPath() {
    const formAction = this.element.action;
    const params = new URLSearchParams();
    const fields = this.element.querySelectorAll("input:not(.ignore-filter), select:not(.ignore-filter)");

    fields.forEach((field) => {
      if (!field.name) {
        return;
      }

      if (field.type === "checkbox" || field.type === "radio") {
        if (field.checked) {
          params.append(field.name, field.value);
        }
        return;
      }

      if (field.value !== "") {
        params.append(field.name, field.value);
      }
    })

    const urlParams = new URLSearchParams(window.location.search);
    urlParams.forEach((value, key) => {
      if (!params.has(key)) {
        params.append(key, value);
      }
    })

    let path = `${formAction.split("?")[0]}?${params.toString()}`;
    this._saveFilters(path)

    return [path, {}];
  }

  /**
   * Generates a unique identifier for the form.
   * @private
   * @returns {String} - Returns a unique identifier
   */
  _getUID() {
    return `filter-form-${new Date().getUTCMilliseconds()}-${Math.floor(Math.random() * 10000000)}`;
  }

  /**
   * Saves the changed filters on sessionStorage API.
   * @private
   * @param {string} pathWithQueryStrings - path with all the query strings for filter.
   * @returns {Void} - Returns nothing.
   */
  _saveFilters(pathWithQueryStrings) {
    if (!window.sessionStorage) {
      return;
    }

    const pathName = this.element.action;
    sessionStorage.setItem("filteredParams", JSON.stringify({[pathName]: pathWithQueryStrings}));
  }
}
