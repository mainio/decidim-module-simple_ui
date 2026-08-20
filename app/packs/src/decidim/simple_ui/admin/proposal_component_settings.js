$(() => {
  const language = document.documentElement.getAttribute("lang") || "en";

  const attachmentsAllowed = document.querySelector("#component_settings_attachments_allowed");
  const mainImage = document.querySelector("#component_settings_main_image");
  const mainImageTranslations = {
    en: {
      helpText: "This setting will add the first image attached to the component listing page and show it highlighted in the single record page."
    },
    fi: {
      helpText: "Tämä asetus lisää ensimmäisen liitetyn kuvan komponentin listausnäkymään sekä näyttää sen korostettuna yksittäisnäkymässä."
    }
  };

  if (!attachmentsAllowed || !mainImage) {
    return;
  }

  const attachmentsAllowedContainer = attachmentsAllowed.closest("div.row.column");
  const mainImageContainer = mainImage.closest("div.row.column");

  attachmentsAllowedContainer.insertAdjacentElement("afterend", mainImageContainer);

  const toggleMainImage = () => {
    mainImageContainer.style.display = attachmentsAllowed.checked
      ? ""
      : "none";

    if (!mainImageContainer.querySelector(".help-text")) {
      const helpText = document.createElement("p");

      helpText.className = "help-text";
      helpText.textContent = mainImageTranslations[language]?.helpText ||
        mainImageTranslations.en.helpText;
      mainImageContainer.appendChild(helpText);
    }
  };

  attachmentsAllowed.addEventListener("change", toggleMainImage);

  toggleMainImage();
});
