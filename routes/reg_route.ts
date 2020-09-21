import * as express from 'express'
import {MongoHelper} from "../bin/MongoHelper";
import { Id } from "../data/types";

const router = express.Router();

router.use((req, res, next) => {
    if (req.header('authentication') !== 'dota2') {
        res.status(401).send({ status: 'unauthorized'})
    } else {
        next()
    }
});

router.get('/register', async (req, res) => {
    const currentId = (await MongoHelper.collection('id').find<Id>().toArray())[0].id + 1;
    await MongoHelper.collection('id').findOneAndUpdate({id: currentId - 1}, {$set: {id: currentId}});
    await MongoHelper.connection.createCollection(`${currentId}`);
    res.status(200).json({ id: currentId })
});

router.post('/sync_event', async (req, res) => {
    const { id } = req.body;
    delete req.body.id;
    await MongoHelper.collection(`${id}`).insertOne(req.body);
    res.status(200).json({ status: 'ok' })
});

router.delete('/delete',
    (req,  res) => MongoHelper.deleteAll()
);

module.exports = router;
