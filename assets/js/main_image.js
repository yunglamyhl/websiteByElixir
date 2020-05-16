$(() => {
    document.getElementById("news_post_image_input").addEventListener("change", readFile);
});

function readFile() {
    console.log("Here!");
    if (this.files && this.files[0]) {

        var FR = new FileReader();

        FR.addEventListener("load", function (e) {
            document.getElementById("news_post_image").value = e.target.result;
            console.log(e.target.result);
        });

        FR.readAsDataURL(this.files[0]);
    }
}