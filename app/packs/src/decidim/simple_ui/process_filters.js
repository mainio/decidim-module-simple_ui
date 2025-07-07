const setFilterText = (target) => {
  const filterPointer = document.querySelector(".active-filter");

  const label = target.closest("label");
  const span = label.querySelector("span");
  const filterName = span.textContent.trim();

  filterPointer.innerHTML = filterName;
}

$(() => {
  const processDate = document.getElementById("panel-dropdown-menu-process-date");
  const datefilterDropdown = document.querySelector(".datefilter-dropdown");
  const caret = datefilterDropdown.querySelector("svg");
  const activeFilter = processDate.querySelector('input[checked="checked"]');

  if(activeFilter) {
    setFilterText(activeFilter);
  }

  const closeDropdown = () => {
    if(!processDate.classList.contains("hidden")) {
      processDate.classList.add("hidden");
      caret.classList.remove("rotate-180");
    }
  }

  processDate.addEventListener("change", (ev) => {
    const target = ev.target;

    if (target.matches('input[name="filter[with_date]"]')) {
      setFilterText(target);
      closeDropdown();
    }
  })

  const toggleDropdown = () => {
    processDate.classList.toggle("hidden");
    caret.classList.toggle("rotate-180");
  }


  datefilterDropdown.addEventListener("click", (ev) => {
    ev.preventDefault();
    toggleDropdown();
  })

  document.addEventListener("click", (ev) => {
    const isInside = processDate.contains(ev.target) || datefilterDropdown.contains(ev.target);
    if (!isInside) {
      closeDropdown();
    }
  })
})
