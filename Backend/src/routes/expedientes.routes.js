import { Router } from "express";
import {
    createExpediente,
    deleteExpediente,
    getAllExpedientes,
    getExpediente,
    updateExpediente,
} from "../controllers/expedientes.controllers.js";

const router = Router();

router.get("/expedientes", getAllExpedientes);
router.get("/expedientes/:id", getExpediente);
router.post("/expedientes/add", createExpediente);
router.put("/expedientes/update/:id", updateExpediente);
router.delete("/expedientes/delete/:id", deleteExpediente);


export default router;