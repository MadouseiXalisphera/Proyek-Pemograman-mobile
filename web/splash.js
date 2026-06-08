// ============================================================================
//  SPLASH AWAL CAFE AMBA  (web/splash.js)
//  Tugas: tampilkan #splash hingga Flutter merender frame pertama, dengan
//  durasi minimal agar branding sempat terlihat (meniru _minShow ~1300ms
//  pada SplashController lama yang sekarang dihapus).
// ============================================================================

(function () {
  'use strict';

  var MIN_SHOW_MS = 1300; // durasi minimal splash tampil
  var SAFETY_MS = 15000;  // paksa hilang jika first-frame tak kunjung datang
  var startedAt = Date.now();
  var removed = false;

  function removeSplash() {
    if (removed) return;
    removed = true;

    var el = document.getElementById('splash');
    if (!el) return;

    el.classList.add('hidden');
    // Buang dari DOM setelah animasi fade (350ms) selesai.
    window.setTimeout(function () {
      if (el && el.parentNode) el.parentNode.removeChild(el);
      // Kembalikan scroll body (di-lock saat splash).
      document.documentElement.style.overflow = '';
      document.body.style.overflow = '';
    }, 400);
  }

  function scheduleRemove() {
    var elapsed = Date.now() - startedAt;
    var wait = Math.max(0, MIN_SHOW_MS - elapsed);
    window.setTimeout(removeSplash, wait);
  }

  // Flutter mengirim event ini begitu frame pertama (login/shell) tampil.
  window.addEventListener('flutter-first-frame', scheduleRemove);

  // Jaring pengaman: jangan biarkan splash nyangkut selamanya.
  window.setTimeout(removeSplash, SAFETY_MS);
})();
