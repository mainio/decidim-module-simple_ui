const setFilterText = (target) => {
  const filterPointer = document.querySelector(".active-filter");

  const label = target.closest("label");
  const span = label.querySelector("span");
  const filterName = span.textContent.trim();

  filterPointer.innerHTML = filterName;
}

$(() => {
  const processDateMenu = document.getElementById("panel-dropdown-menu-process-date");
  const dateFilterTrigger = document.getElementById("trigger-menu-process-date");
  const caret = dateFilterTrigger.querySelector("svg");
  const activeFilter = processDateMenu.querySelector('input[checked="checked"]');

  if(activeFilter) {
    setFilterText(activeFilter);
  }

  const closeDropdown = () => {
    if(!processDateMenu.classList.contains("hidden")) {
      processDateMenu.classList.add("hidden");
      caret.classList.remove("rotate-180");
    }
  }

  processDateMenu.addEventListener("change", (ev) => {
    const target = ev.target;

    if (target.matches('input[name="filter[with_date]"]')) {
      setFilterText(target);
      closeDropdown();
    }
  })

  const toggleDropdown = () => {
    processDateMenu.classList.toggle("hidden");
    caret.classList.toggle("rotate-180");
  }

  dateFilterTrigger.addEventListener("click", (ev) => {
    ev.preventDefault();
    toggleDropdown();
    const radios = processDateMenu.querySelectorAll('input[type="radio"][name="filter[with_date]"]');

    if (ev.detail === 0) {
      if (activeFilter) {
        activeFilter.focus()
      } else {
        radios[0].focus();
      }
    }
  })

  document.addEventListener("click", (ev) => {
    const isInside = processDateMenu.contains(ev.target) || dateFilterTrigger.contains(ev.target);
    if (!isInside) {
      closeDropdown();
    }
  })
})
