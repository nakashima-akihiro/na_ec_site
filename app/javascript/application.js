// Entry point for the build script in your package.json.
import "@hotwired/turbo-rails"

// Stimulus controllers.
import "./controllers"

// ドロップダウンメニュー開閉
document.addEventListener('DOMContentLoaded', function() {
  document.querySelectorAll('.dropdown').forEach(function(dropdown) {
    const button = dropdown.querySelector('button');
    button.addEventListener('click', function(e) {
      e.stopPropagation();
      dropdown.classList.toggle('open');
    });
  });
  // 外側クリックで閉じる
  document.addEventListener('click', function(e) {
    document.querySelectorAll('.dropdown.open').forEach(function(openDropdown) {
      if (!openDropdown.contains(e.target)) {
        openDropdown.classList.remove('open');
      }
    });
  });
});