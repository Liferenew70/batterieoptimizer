/* ================================================================
   BATTERYOPTIMIZER PRO ULTRA — INTERACTIONS
   Thèmes, navigation mobile, FAQ accordéon, effet de frappe du
   terminal héros, révélations au scroll. Aucune dépendance externe.
   ================================================================ */
(function () {
  "use strict";

  var prefersReducedMotion = window.matchMedia("(prefers-reduced-motion: reduce)").matches;

  /* --------------------------------------------------------------
     Remplace par l'URL réelle du dépôt GitHub une fois le site en
     ligne : tous les liens .nav-github / .download-github-link
     pointent vers cette constante.
     -------------------------------------------------------------- */
  var GITHUB_REPO_URL = "https://github.com/";
  document.querySelectorAll('a[href="https://github.com/"]').forEach(function (a) {
    a.href = GITHUB_REPO_URL;
  });

  /* ----------------------------------------------------------------
     1. THEMES
     Etat gardé en mémoire (pas de localStorage : ce fichier peut être
     prévisualisé dans un cadre sandboxé qui ne l'autorise pas). Une
     fois hébergé sur GitHub Pages, remplace `memoryTheme` par une
     lecture/écriture localStorage si tu veux que le choix persiste
     d'une visite à l'autre.
  ---------------------------------------------------------------- */
  var THEMES = ["terminal", "ambre", "jour", "circuit"];
  var root = document.documentElement;
  var themeButtons = document.querySelectorAll("[data-theme-btn]");
  var memoryTheme = "terminal";

  function applyTheme(theme) {
    if (THEMES.indexOf(theme) === -1) theme = "terminal";
    memoryTheme = theme;
    root.setAttribute("data-theme", theme);
    themeButtons.forEach(function (btn) {
      var isActive = btn.getAttribute("data-theme-btn") === theme;
      btn.setAttribute("aria-pressed", isActive ? "true" : "false");
    });
  }

  themeButtons.forEach(function (btn) {
    btn.addEventListener("click", function () {
      applyTheme(btn.getAttribute("data-theme-btn"));
    });
  });

  applyTheme(memoryTheme);

  /* ----------------------------------------------------------------
     2. NAVIGATION MOBILE
  ---------------------------------------------------------------- */
  var navToggle = document.getElementById("nav-toggle");
  var mainNav = document.getElementById("main-nav");

  if (navToggle && mainNav) {
    navToggle.addEventListener("click", function () {
      var isOpen = mainNav.classList.toggle("is-open");
      navToggle.setAttribute("aria-expanded", isOpen ? "true" : "false");
      navToggle.setAttribute("aria-label", isOpen ? "Fermer le menu de navigation" : "Ouvrir le menu de navigation");
    });

    mainNav.querySelectorAll("a").forEach(function (link) {
      link.addEventListener("click", function () {
        mainNav.classList.remove("is-open");
        navToggle.setAttribute("aria-expanded", "false");
      });
    });
  }

  /* ----------------------------------------------------------------
     3. FAQ ACCORDEON
  ---------------------------------------------------------------- */
  document.querySelectorAll(".faq-trigger").forEach(function (trigger) {
    trigger.addEventListener("click", function () {
      var item = trigger.closest(".faq-item");
      var isOpen = item.classList.contains("is-open");

      document.querySelectorAll(".faq-item.is-open").forEach(function (openItem) {
        if (openItem !== item) {
          openItem.classList.remove("is-open");
          openItem.querySelector(".faq-trigger").setAttribute("aria-expanded", "false");
        }
      });

      item.classList.toggle("is-open", !isOpen);
      trigger.setAttribute("aria-expanded", isOpen ? "false" : "true");
    });
  });

  /* ----------------------------------------------------------------
     4. EFFET DE FRAPPE — terminal du hero
     Respecte prefers-reduced-motion : affichage instantané si activé.
  ---------------------------------------------------------------- */
  var typingEl = document.getElementById("hero-typing");

  if (typingEl) {
    var fullText = typingEl.getAttribute("data-full-text") || typingEl.textContent;

    if (prefersReducedMotion) {
      typingEl.textContent = fullText;
    } else {
      typingEl.textContent = "";
      var cursor = document.createElement("span");
      cursor.className = "cursor";
      typingEl.appendChild(cursor);

      var i = 0;
      var speed = 12; /* ms par caractère */

      (function typeNext() {
        if (i < fullText.length) {
          cursor.insertAdjacentText("beforebegin", fullText.charAt(i));
          i++;
          setTimeout(typeNext, speed);
        }
      })();
    }
  }

  /* ----------------------------------------------------------------
     5. REVELATIONS AU SCROLL
  ---------------------------------------------------------------- */
  var revealTargets = document.querySelectorAll(
    ".feature-card, .step-card, .term-window, .download-card, .trust-item"
  );

  revealTargets.forEach(function (el) { el.setAttribute("data-reveal", ""); });

  if (prefersReducedMotion || !("IntersectionObserver" in window)) {
    revealTargets.forEach(function (el) { el.classList.add("is-visible"); });
  } else {
    var observer = new IntersectionObserver(
      function (entries) {
        entries.forEach(function (entry) {
          if (entry.isIntersecting) {
            entry.target.classList.add("is-visible");
            observer.unobserve(entry.target);
          }
        });
      },
      { threshold: 0.12, rootMargin: "0px 0px -40px 0px" }
    );
    revealTargets.forEach(function (el) { observer.observe(el); });
  }

  /* ----------------------------------------------------------------
     6. EN-TETE — ombre légère au scroll
  ---------------------------------------------------------------- */
  var header = document.querySelector(".site-header");
  if (header) {
    var onScroll = function () {
      header.style.boxShadow = window.scrollY > 8 ? "0 8px 20px -16px rgba(0,0,0,.6)" : "none";
    };
    window.addEventListener("scroll", onScroll, { passive: true });
    onScroll();
  }
})();
