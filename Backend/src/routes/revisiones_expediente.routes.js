import { Router } from "express";
import {
    createRevExpediente,
    deleteRevExpediente,
    getAllRevExpedientes,
    getRevExpediente,
    updateRevExpediente,
} from "../controllers/revision_expediente.controllers.js";

const router = Router();

router.get("/rev_expedientes", getAllRevExpedientes);
router.get("/rev_expedientes/:id", getRevExpediente);
router.post("/rev_expedientes/add", createRevExpediente);
router.put("/rev_expedientes/update/:id", updateRevExpediente);
router.delete("/rev_expedientes/delete/:id", deleteRevExpediente);


export default router;