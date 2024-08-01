const router = require("express").Router();
const { getAllUsers, saveUser, updateUser, getUserByUsername } = require("../controllers/redis_controller");

router.patch("/update", updateUser);
router.post("/create", saveUser);
router.get("/all", getAllUsers);
router.get("/", getUserByUsername);

module.exports = router;