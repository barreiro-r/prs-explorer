// Ensure the DOM is fully loaded before attaching event listeners
document.addEventListener('DOMContentLoaded', function() {
    // Get modal elements
    const openModalButton = document.getElementById('openModalButton');
    const closeModalButton = document.getElementById('closeModalButton');
    const slideshowModal = document.getElementById('slideshowModal');
    const modalBackdrop = document.getElementById('modalBackdrop');

    // Get slideshow elements
    const slides = document.querySelectorAll('.slide-item');
    let currentSlide = 0; // Index of the currently visible slide

    // Function to display a specific slide
    function showSlide(index) {
        // Hide all slides
        slides.forEach(slide => {
            slide.classList.remove('active');
        });

        // Validate index to loop slideshow
        if (index >= slides.length) {
            currentSlide = 0; // Loop to the first slide
        } else if (index < 0) {
            currentSlide = slides.length - 1; // Loop to the last slide
        } else {
            currentSlide = index;
        }

        // Show the target slide
        if (slides[currentSlide]) {
            slides[currentSlide].classList.add('active');
        }
    }

    // Function to change slide (next/prev)
    // Make this function globally accessible if called by inline onclick
    // However, it's better practice to attach event listeners in JS
    window.changeSlide = function(direction) {
        showSlide(currentSlide + direction);
    }

    // Function to open the modal
    function openModal() {
        if (slideshowModal && modalBackdrop) {
            slideshowModal.style.display = 'block';
            modalBackdrop.style.display = 'block';
            document.body.style.overflow = 'hidden'; // Prevent background scrolling
            showSlide(0); // Show the first slide when modal opens
        }
    }

    // Function to close the modal
    function closeModal() {
        if (slideshowModal && modalBackdrop) {
            slideshowModal.style.display = 'none';
            modalBackdrop.style.display = 'none';
            document.body.style.overflow = 'auto'; // Restore background scrolling
        }
    }

    // Event Listeners
    if (openModalButton) {
        openModalButton.addEventListener('click', openModal);
    }
    if (closeModalButton) {
        closeModalButton.addEventListener('click', closeModal);
    }

    // Close modal if backdrop is clicked
    if (modalBackdrop) {
        modalBackdrop.addEventListener('click', closeModal);
    }

    // Close modal with Escape key
    document.addEventListener('keydown', function(event) {
        if (slideshowModal && slideshowModal.style.display === 'block' && event.key === 'Escape') {
            closeModal();
        }
    });

    // Initialize the slideshow by showing the first slide (though it's hidden initially with the modal)
    // This ensures that when the modal becomes visible, the first slide is already set as active.
    if (slides.length > 0) {
        showSlide(currentSlide); // Initialize the first slide
    }

    // If you prefer not to use inline onclick for arrows, you can attach listeners here:
    const prevArrow = document.querySelector('.slideshow-content .prev.nav-arrow');
    const nextArrow = document.querySelector('.slideshow-content .next.nav-arrow');

    if (prevArrow) {
        prevArrow.addEventListener('click', function() {
            changeSlide(-1);
        });
    }
    if (nextArrow) {
        nextArrow.addEventListener('click', function() {
            changeSlide(1);
        });
    }
    // If you attach listeners here, you can remove the onclick="changeSlide(...)" from the HTML/R tags.
    // For simplicity with Shiny tags and direct HTML translation, I kept the onclick in the R code.
    // If you remove them, make sure `changeSlide` is NOT on the window object.
});
