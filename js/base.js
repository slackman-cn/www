function applyTopPadding() {
    // Update various absolute positions to match where the main container
    // starts. This is necessary for handling multi-line nav headers, since
    // that pushes the main container down.
    var container = document.querySelector('body > .container');
    var offset = container.offsetTop;

    document.documentElement.style.scrollPaddingTop = offset + 'px';
    document.querySelectorAll('.bs-sidebar.affix').forEach(function(sidebar) {
        sidebar.style.top = offset + 'px';
    });
}

document.addEventListener("DOMContentLoaded", function () {
    document.querySelectorAll('table').forEach(function(table) {
      table.classList.add('table', 'table-striped', 'table-hover');
    });

    function showInnerDropdown(item) {
      var popup = item.nextElementSibling;
      popup.classList.add('show');
      item.classList.add('open');

      // First, close any sibling dropdowns.
      var container = item.parentElement.parentElement;
      container.querySelectorAll('> .dropdown-submenu > a').forEach(function(el) {
          if (el !== item) {
              hideInnerDropdown(el);
          }
      });

      var popupMargin = 10;
      var maxBottom = window.innerHeight - popupMargin;
      var bounds = item.getBoundingClientRect();

      popup.style.left = bounds.right + 'px';
      if (bounds.top + popup.clientHeight > maxBottom &&
          bounds.top > window.innerHeight / 2) {
          popup.style.top = (bounds.bottom - popup.clientHeight) + 'px';
          popup.style.maxHeight = (bounds.bottom - popupMargin) + 'px';
      } else {
          popup.style.top = bounds.top + 'px';
          popup.style.maxHeight = (maxBottom - bounds.top) + 'px';
      }
    }

    function hideInnerDropdown(item) {
        var popup = item.nextElementSibling;
        popup.classList.remove('show');
        item.classList.remove('open');

        popup.scrollTop = 0;
        popup.querySelector('.dropdown-menu').scrollTop = 0;
        popup.querySelector('.dropdown-submenu > a').classList.remove('open');
    }

    document.querySelectorAll('.dropdown-submenu > a').forEach(function(item) {
        item.addEventListener('click', function(e) {
            if (item.nextElementSibling.classList.contains('show')) {
                hideInnerDropdown(item);
            } else {
                showInnerDropdown(item);
            }

            e.stopPropagation();
            e.preventDefault();
        });
    });

    document.querySelectorAll('.dropdown-menu').forEach(function(menu) {
        menu.parentElement.addEventListener('hide.bs.dropdown', function() {
            menu.scrollTop = 0;
            menu.querySelector('.dropdown-submenu > a').classList.remove('open');
            menu.querySelectorAll('.dropdown-menu .dropdown-menu').forEach(function(submenu) {
                submenu.classList.remove('show');
            });
        });
    });

    applyTopPadding();
});

window.addEventListener('resize', applyTopPadding);

var scrollSpy = new bootstrap.ScrollSpy(document.body, {
    target: '.bs-sidebar'
});

/* Prevent disabled links from causing a page reload */
document.querySelectorAll("li.disabled a").forEach(function(item) {
    item.addEventListener("click", function(event) {
        event.preventDefault();
    });
});

