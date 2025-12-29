$(() => {
  const language = document.documentElement.getAttribute("lang") || "en";

  const attachmentsAllowed = document.querySelector("#component_settings_attachments_allowed");
  const mainImage = document.querySelector("#component_settings_main_image");
  const main_image_translations = {
    en: {
      main_image_help_text: "This setting will add the first image attached to the component listing page and show it highlighted in the single record page."
    },
    fi: {
      main_image_help_text: "Tämä asetus lisää ensimmäisen liitetyn kuvan komponentin listausnäkymään sekä näyttää sen korostettuna yksittäisnäkymässä."
    }
  }

  if (!attachmentsAllowed || !mainImage) { return; }

  const attachmentsAllowedContainer = attachmentsAllowed.closest("div.row.column");
  const mainImageContainer = mainImage.closest("div.row.column");

  attachmentsAllowedContainer.insertAdjacentElement("afterend", mainImageContainer);

  const toggleMainImage = () => {
    mainImageContainer.style.display = attachmentsAllowed.checked ? "" : "none";

    if (!mainImageContainer.querySelector(".help-text")) {
      const helpText = document.createElement("p");

      helpText.className = "help-text";
      helpText.textContent = main_image_translations[language]?.main_image_help_text
        || main_image_translations["en"].main_image_help_text;
      mainImageContainer.appendChild(helpText);
    }
  }

  attachmentsAllowed.addEventListener("change", toggleMainImage);

  toggleMainImage();
})
