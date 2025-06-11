const setFilterText = (target) => {
  const filterPointer = document.querySelector(".active-filter");

  const label = target.closest("label");
  const span = label.querySelector("span");
  const filterName = span.textContent.trim();

  filterPointer.innerHTML = filterName;
}

$(() => {
  const processDate = document.getElementById("panel-dropdown-menu-process-date");
  const activeFilter = processDate.querySelector('input[checked="checked"]');

  setFilterText(activeFilter);

  processDate.addEventListener("change", (ev) => {
    const target = ev.target;

    if (target.matches('input[name="filter[with_date]"]')) {
      setFilterText(target);
    }
  })

  const datefilterDropdown = document.querySelector(".datefilter-dropdown");
  const processDateMenu = document.getElementById("panel-dropdown-menu-process-date");
  const caret = datefilterDropdown.querySelector("svg");

  datefilterDropdown.addEventListener("click", (ev) => {
    ev.preventDefault();
    processDateMenu.classList.toggle("hidden");
    caret.classList.toggle("rotate-180");
  })
})
