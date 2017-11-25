jQuery(document).ready(function($) {
	//toggle 3d navigation
	$('.navbar-buttons-trigger').on('click', function() {
        var marker = $('.navbar-marker');
        var selectedItem = $('.navbar-buttons-selected');
        marker.width(selectedItem.width());
		toggle3dBlock(!$('.navbar-header').hasClass('nav-visible'));
	});

	//select a new item from the 3d navigation
	$('.navbar-buttons').on('click', 'a', function() {
		var selected = $(this);
		selected.parent('li').addClass('navbar-buttons-selected').siblings('li').removeClass('navbar-buttons-selected');
		updateSelectedNav('close');
	});

	$(window).on('resize', function() {
		window.requestAnimationFrame(updateSelectedNav);
	});

	function toggle3dBlock(addOrRemove) {
		if (typeof(addOrRemove)==='undefined') addOrRemove = true;	
		$('.navbar-header').toggleClass('nav-visible', addOrRemove);
		$('.navbar-container').toggleClass('nav-visible', addOrRemove);
		$('main').toggleClass('nav-visible', addOrRemove).one('webkitTransitionEnd otransitionend oTransitionEnd msTransitionEnd transitionend', function() {
			//fix marker position when opening the menu (after a window resize)
			addOrRemove && updateSelectedNav();
		});
	}

	//this function update the .cd-marker position
	function updateSelectedNav(type) {
		var selectedItem = $('.navbar-buttons-selected'),
			selectedItemPosition = selectedItem.index() + 1, 
			leftPosition = selectedItem.offset().left,
			backgroundColor = selectedItem.data('navbar-color'),
			marker = $('.navbar-marker');

        marker.width(selectedItem.width());
		marker.removeClassPrefix('navbar-color').addClass('navbar-color-'+ selectedItemPosition).css({
			'left': leftPosition,
		});
		if (type == 'close') {
			marker.one('webkitTransitionEnd otransitionend oTransitionEnd msTransitionEnd transitionend', function(){
				toggle3dBlock(false);
			});
		}
	}

	$.fn.removeClassPrefix = function(prefix) {
	    this.each(function(i, el) {
	        var classes = el.className.split(" ").filter(function(c) {
	            return c.lastIndexOf(prefix, 0) !== 0;
	        });
	        el.className = $.trim(classes.join(" "));
	    });
	    return this;
	};
});
