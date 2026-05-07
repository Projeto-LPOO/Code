/* =========================================
   Infinity Aura - userProfile.js
========================================= */

(function () {

    'use strict';

    /*
    |--------------------------------------------------------------------------
    | Fade animation on scroll
    |--------------------------------------------------------------------------
    */

    const animatedElements = document.querySelectorAll('.fade-up');

    const observer = new IntersectionObserver((entries) => {

        entries.forEach((entry) => {

            if (entry.isIntersecting) {

                entry.target.style.opacity = '1';
                entry.target.style.transform = 'translateY(0)';

            }

        });

    }, {
        threshold: 0.1
    });

    animatedElements.forEach((element) => {

        element.style.opacity = '0';
        element.style.transform = 'translateY(20px)';
        element.style.transition = 'all 0.5s ease';

        observer.observe(element);

    });

    /*
    |--------------------------------------------------------------------------
    | Hover micro interaction
    |--------------------------------------------------------------------------
    */

    const cards = document.querySelectorAll('.content-card, .profile-card');

    cards.forEach((card) => {

        card.addEventListener('mouseenter', () => {

            card.style.transform = 'translateY(-2px)';
            card.style.transition = '0.2s ease';

        });

        card.addEventListener('mouseleave', () => {

            card.style.transform = 'translateY(0)';

        });

    });

})();