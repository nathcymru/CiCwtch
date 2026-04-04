(function () {
  function setupTabs() {
    var tabButtons = Array.from(document.querySelectorAll('[role="tab"]'));
    var tabPanels = Array.from(document.querySelectorAll('[role="tabpanel"]'));
    if (!tabButtons.length || !tabPanels.length) return;

    function getTabKey(tab) {
      return tab.dataset.tab || tab.id.replace(/^tab-/, '');
    }

    function findTabFromHash() {
      var hash = window.location.hash.replace(/^#/, '');
      if (!hash) return null;
      return tabButtons.find(function (b) { return getTabKey(b) === hash; }) || null;
    }

    function activateTab(tab, options) {
      var updateHash = options && options.updateHash !== undefined ? options.updateHash : true;
      var targetId = tab.getAttribute('aria-controls');
      var tabKey = getTabKey(tab);

      tabButtons.forEach(function (button) {
        var selected = button === tab;
        button.setAttribute('aria-selected', String(selected));
        button.tabIndex = selected ? 0 : -1;
      });

      tabPanels.forEach(function (panel) {
        panel.hidden = panel.id !== targetId;
      });

      if (updateHash && tabKey) {
        if (history.replaceState) {
          history.replaceState(null, '', '#' + tabKey);
        } else {
          window.location.hash = tabKey;
        }
      }
    }

    tabButtons.forEach(function (button, index) {
      button.addEventListener('click', function () { activateTab(button); });
      button.addEventListener('keydown', function (event) {
        var nextIndex = null;
        if (event.key === 'ArrowDown' || event.key === 'ArrowRight') {
          nextIndex = (index + 1) % tabButtons.length;
        } else if (event.key === 'ArrowUp' || event.key === 'ArrowLeft') {
          nextIndex = (index - 1 + tabButtons.length) % tabButtons.length;
        } else if (event.key === 'Home') {
          nextIndex = 0;
        } else if (event.key === 'End') {
          nextIndex = tabButtons.length - 1;
        }
        if (nextIndex !== null) {
          event.preventDefault();
          tabButtons[nextIndex].focus();
          activateTab(tabButtons[nextIndex]);
        }
      });
    });

    var initialTab = findTabFromHash() || tabButtons[0];
    activateTab(initialTab, { updateHash: Boolean(findTabFromHash()) });

    window.addEventListener('hashchange', function () {
      var matchedTab = findTabFromHash();
      if (matchedTab) activateTab(matchedTab, { updateHash: false });
    });
  }

  function cleanupTrustDocs() {
    var docs = Array.from(document.querySelectorAll('.trust-doc'));
    if (!docs.length) return;
    docs.forEach(function (doc) {
      while (doc.firstChild && doc.firstChild.nodeType === Node.TEXT_NODE && !doc.firstChild.textContent.trim()) {
        doc.removeChild(doc.firstChild);
      }
      while (doc.firstChild && doc.firstChild.nodeType === Node.COMMENT_NODE) {
        doc.removeChild(doc.firstChild);
      }
      while (doc.firstElementChild && doc.firstElementChild.tagName === 'BR') {
        doc.firstElementChild.remove();
      }
      var firstTable = doc.querySelector(':scope > table:first-of-type');
      if (firstTable) {
        firstTable.style.marginTop = '0';
        firstTable.style.marginBottom = '20px';
        firstTable.querySelectorAll('td, th').forEach(function (cell) { cell.style.paddingTop = '0'; });
        firstTable.querySelectorAll('h1, h2, h3, p').forEach(function (el) { el.style.marginTop = '0'; });
      }
    });
  }

  document.addEventListener('DOMContentLoaded', function () {
    setupTabs();
    cleanupTrustDocs();
  });
})();
