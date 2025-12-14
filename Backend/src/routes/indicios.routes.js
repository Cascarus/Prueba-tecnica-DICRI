import { Router } from "express";
import {
    createIndicio,
    deleteIndicio,
    getAllIndicios,
    getIndicio,
    updateIndicio,
} from "../controllers/indicios.controllers.js";

const router = Router();

router.get("/indicios", getAllIndicios);
router.get("/indicios/:id", getIndicio);
router.post("/indicios/add", createIndicio);
router.put("/indicios/update/:id", updateIndicio);
router.delete("/indicios/delete/:id", deleteIndicio);


export default router;