// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.

//= require jquery3
//= require popper
//= require bootstrap-sprockets

//= require rails-ujs
//= require activestorage
//= require turbolinks
//= require_tree .

// 投稿一覧画面のslick設定
$(document).on('turbolinks:load', function() {
    $('.slick').slick({
        dots: true,
        infinite: true,
        speed: 200,
    });
});

// aboutページのslick設定
$(document).on('turbolinks:load', function() {
    $('.about-slick').slick({
        arrows: false,
        autoplay:true,
        speed: 700,
        fade:true,
        autoplaySpeed:4000,
    });
});

// 新規投稿画面のpreview設定
function loadImage(obj)
{
    document.getElementById('preview').innerHTML = '<p>選択した画像</p>';
    for (i = 0; i < obj.files.length; i++) {
    	var fileReader = new FileReader();
    	fileReader.onload = (function (e) {
    		document.getElementById('preview').innerHTML += '<img src="' + e.target.result + '">';
    	});
    	fileReader.readAsDataURL(obj.files[i]);
    }
}