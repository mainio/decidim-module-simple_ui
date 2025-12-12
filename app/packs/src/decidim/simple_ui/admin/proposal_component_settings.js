$(() => {
  const attachmentsAllowed = document.querySelector("#component_settings_attachments_allowed");
  const mainImage = document.querySelector("#component_settings_main_image");

  if (!attachmentsAllowed || !mainImage) { return; }

  const attachmentsAllowedContainer = attachmentsAllowed.closest("div.row.column");
  const mainImageContainer = mainImage.closest("div.row.column");

  attachmentsAllowedContainer.insertAdjacentElement("afterend", mainImageContainer);

  const toggleMainImage = () => {
    mainImageContainer.style.display = attachmentsAllowed.checked ? "" : "none";

    if (!mainImageContainer.querySelector(".help-text")) {
      const helpText = document.createElement("p");

      helpText.className = "help-text";
      // helpText.textContent = I18n.t("decidim.admin.components.proposals.settings.global.main_image_help_text");
      helpText.textContent = "Placeholder"
      mainImageContainer.appendChild(helpText);
    }
  }

  attachmentsAllowed.addEventListener("change", toggleMainImage);

  toggleMainImage();
})
