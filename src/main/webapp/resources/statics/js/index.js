var images;

$('.message a').click(function(){
    $('form').animate({height: "toggle", opacity: "toggle"}, "slow");
});

function send() {
    var c = document.getElementById("myCanvas");
//var ctx = c.getContext("2d");
//var img = document.getElementById("sourceImg");
//ctx.drawImage(img, 10, 10);
//alert(c.toDataURL());
    document.getElementById("bytes").value = c.toDataURL();

    var string = $('form[name=string]').serialize();
    //alert(string);
    $.post('/saveImage', string, function (data) {

    });
    location.reload();
}

window.onload = function() {
    /*var c = document.getElementById("myCanvas");
    var ctx = c.getContext("2d");
    var img = document.getElementById("sourceImg");
    ctx.drawImage(img, 10, 10);
    //alert(c.toDataURL());
    document.getElementById("bytes").value = c.toDataURL();*/
};


///////////////////video

// References to all the element we will need.
var video = document.querySelector('#camera-stream'),
    image = document.querySelector('#snap'),
    start_camera = document.querySelector('#start-camera'),
    controls = document.querySelector('.controls'),
    take_photo_btn = document.querySelector('#take-photo'),
    delete_photo_btn = document.querySelector('#delete-photo'),
    download_photo_btn = document.querySelector('#download-photo'),

    download_photo_to_base_btn = document.querySelector('#save-photo'),

    error_message = document.querySelector('#error-message');


// The getUserMedia interface is used for handling camera input.
// Some browsers need a prefix so here we're covering all the options
navigator.getMedia = ( navigator.getUserMedia ||
    navigator.webkitGetUserMedia ||
    navigator.mozGetUserMedia ||
    navigator.msGetUserMedia);


if(!navigator.getMedia){
    displayErrorMessage("Your browser doesn't have support for the navigator.getUserMedia interface.");
}
else{

// Request the camera.
    navigator.getMedia(
        {
            video: true
            //audio: true
        },
        // Success Callback
        function(stream){

            // Create an object URL for the video stream and
            // set it as src of our HTLM video element.
            video.src = window.URL.createObjectURL(stream);

            // Play the video element to start the stream.
            video.play();
            video.onplay = function() {
                showVideo();
            };

        },
        // Error Callback
        function(err){
            displayErrorMessage("There was an error with accessing the camera stream: " + err.name, err);
        }
    );

}



// Mobile browsers cannot play video without user input,
// so here we're using a button to start it manually.
start_camera.addEventListener("click", function(e){

    e.preventDefault();

// Start video playback manually.
    video.play();
    showVideo();

});


take_photo_btn.addEventListener("click", function(e){

    e.preventDefault();

    var snap = takeSnapshot();

// Show image.
    image.setAttribute('src', snap);
    image.classList.add("visible");

// Enable delete and save buttons
    delete_photo_btn.classList.remove("disabled");
    download_photo_btn.classList.remove("disabled");

    download_photo_to_base_btn.classList.remove("disabled");

// Set the href attribute of the download button to the snap url.
    download_photo_btn.href = snap;

// Pause video playback of stream.
    video.pause();

});

download_photo_to_base_btn.addEventListener("click", function (evt) {
    evt.preventDefault();
// Hide image.
    image.setAttribute('src', "");
    image.classList.remove("visible");

// Disable delete and save buttons
    delete_photo_btn.classList.add("disabled");
    download_photo_btn.classList.add("disabled");

    download_photo_to_base_btn.classList.add("disabled");

// Resume playback of stream.
    video.play();
    send();
});


delete_photo_btn.addEventListener("click", function(e){

    e.preventDefault();

// Hide image.
    image.setAttribute('src', "");
    image.classList.remove("visible");

// Disable delete and save buttons
    delete_photo_btn.classList.add("disabled");
    download_photo_btn.classList.add("disabled");

    download_photo_to_base_btn.classList.add("disabled");

// Resume playback of stream.
    video.play();

});



function showVideo(){
// Display the video stream and the controls.

    hideUI();
    video.classList.add("visible");
    controls.classList.add("visible");
}


function takeSnapshot(){
// Here we're using a trick that involves a hidden canvas element.

    var hidden_canvas = document.querySelector('canvas'),
        context = hidden_canvas.getContext('2d');

    var width = video.videoWidth,
        height = video.videoHeight;

    if (width && height) {

        // Setup a canvas with the same dimensions as the video.
        hidden_canvas.width = width;
        hidden_canvas.height = height;

        // Make a copy of the current frame in the video on the canvas.
        context.drawImage(video, 0, 0, width, height);

        // Turn the canvas image into a dataURL that can be used as a src for our photo.
        return hidden_canvas.toDataURL('image/png');
    }
}


function displayErrorMessage(error_msg, error){
    error = error || "";
    if(error){
        console.log(error);
    }

    error_message.innerText = error_msg;

    hideUI();
    error_message.classList.add("visible");
}


function hideUI(){
// Helper function for clearing the app UI.

    controls.classList.remove("visible");
    start_camera.classList.remove("visible");
    video.classList.remove("visible");
    snap.classList.remove("visible");
    error_message.classList.remove("visible");
}

function showHideAboutImage(image) {
    //alert(image.getAttribute("src"));
    $( "#bigImage" ).attr("src", image.getAttribute("src"));
    $( "#saveFoto" ).attr("src", image.getAttribute("src"));
    $( "#idFoto" ).val(image.getAttribute("name"));
    $( "#aboutFoto" ).toggle();
}

$( '#closeFoto').click(function () {
    $( "#aboutFoto" ).toggle();
});

function saveBase64AsFile(/*base64, fileName*/) {
    var link = document.createElement("a");
    //link.setAttribute("href", base64);
    link.setAttribute("href", document.getElementById("bigImage").getAttribute("src"));
    link.setAttribute("download", "New File.png");
    link.click();
}

function deleteFoto() {
    var id = $( '#idFoto' ).val();
    //alert( id );
    $.ajax({
        url: "/deleteImage/" + id,
        type: "GET",
        dataType: "json",
        success : function(list) {
        }
    });
    location.reload();
}


/*images = $('#images-table').dataTable( {
    "dom": '<"top"i>rt<"bottom"flp><"clear">',
    "sAjaxDataProp": "",
    "sAjaxSource": "/images",
    "order": [[ 0, "asc" ]],
    "columns": [
        { "data": "id"},
        { "data": "name" },
        { "data": "bytes" },
        { "data": "user_id" },
        { "data": "created_at" }
    ]
} );*/
