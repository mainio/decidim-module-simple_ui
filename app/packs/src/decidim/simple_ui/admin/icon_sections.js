import AutoButtonsByPositionComponent from "src/decidim/admin/auto_buttons_by_position.component"
import AutoLabelByPositionComponent from "src/decidim/admin/auto_label_by_position.component"
import createDynamicFields from "src/decidim/admin/dynamic_fields.component"
import createSortList from "src/decidim/admin/sort_list.component"

$(() => {
  const dynamicFieldDefinitions = [
    {
      placeHolderId: "icon-section-id",
      wrapperSelector: ".icon-sections",
      fieldSelector: ".icon-section",
      addFieldSelector: ".add-icon-section"
    }
  ];

  dynamicFieldDefinitions.forEach((section) => {
    const fieldSelectorSuffix = section.fieldSelector.replace(".", "");

    const autoButtonsByPosition = new AutoButtonsByPositionComponent({
      listSelector: `${section.fieldSelector}:not(.hidden)`,
      hideOnFirstSelector: ".move-up-question",
      hideOnLastSelector: ".move-down-question"
    });

    const autoLabelByPosition = new AutoLabelByPositionComponent({
      listSelector: `${section.fieldSelector}:not(.hidden)`,
      labelSelector: ".card-title span:first",
      onPositionComputed: (el, idx) => {
        $(el).find("input[name$=\\[position\\]]").val(idx);
      }
    });

    const createSortableList = () => {
      createSortList(".icon-sections-list:not(.published)", {
        handle: ".icon-section-divider",
        placeholder: '<div style="border-style: dashed; border-color: #000"></div>',
        forcePlaceholderSize: true,
        onSortUpdate: () => {
          autoLabelByPosition.run();
          autoButtonsByPosition.run();
        }
      });
    };

    const hideDeletedItem = ($target) => {
      const inputDeleted = $target.find("input[name$=\\[deleted\\]]").val();

      if (inputDeleted === "true") {
        $target.addClass("hidden");
        $target.hide();

        // Allows re-submitting of the form
        $("input", $target).removeAttr("required");
      }
    };

    createDynamicFields({
      placeholderId: section.placeHolderId,
      wrapperSelector: section.wrapperSelector,
      containerSelector: `${section.wrapperSelector}-list`,
      fieldSelector: section.fieldSelector,
      addFieldButtonSelector: section.addFieldSelector,
      removeFieldButtonSelector: `.remove-${fieldSelectorSuffix}`,
      moveUpFieldButtonSelector: ".move-up-question",
      moveDownFieldButtonSelector: ".move-down-question",
      onAddField: ($field) => {
        createSortableList();

        autoLabelByPosition.run();
        autoButtonsByPosition.run();

        const id = $field.attr("id").split("-")[0];
        const idInput = $field[0].querySelector("input[type='hidden'][name$='[id]']");
        idInput.setAttribute("value", id);
      },
      onRemoveField: ($field) => {
        autoLabelByPosition.run();
        autoButtonsByPosition.run();

        // Remove the whole field so that the deleted fields are not stored
        // within the block settings.
        $field.remove();
      },
      onMoveUpField: () => {
        autoLabelByPosition.run();
        autoButtonsByPosition.run();
      },
      onMoveDownField: () => {
        autoLabelByPosition.run();
        autoButtonsByPosition.run();
      }
    });

    createSortableList();

    $(section.fieldSelector).each((_idx, el) => {
      const $target = $(el);

      hideDeletedItem($target);
    });

    autoLabelByPosition.run();
    autoButtonsByPosition.run();
  });
});
