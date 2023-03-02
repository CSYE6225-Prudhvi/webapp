const multer = require("multer");

const storage = multer.diskStorage({
    destination: function (req, file, cb) {
        cb(null, "uploads/");
    },

    filename: function (req, file, cb) {
        const imgName = file.originalname;
        cb(null, imgName + '_' + Date.now());
    },
});

const upload = multer({
    storage: storage
});

module.exports = upload;