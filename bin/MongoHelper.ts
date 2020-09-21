import * as mongoose from "mongoose";
import * as Mongoose from "mongoose";
import {Collection, Promise} from "mongoose";
import {Id} from "../data/types";
import validate = WebAssembly.validate;

export class MongoHelper {
    static connection: mongoose.Connection;

    static initMongo() {
        const uri = "mongodb+srv://glebik8:2QkO1Io11NilgSKz@cluster0.2olbh.mongodb.net/users?retryWrites=true&w=majority";
        Mongoose.connect(uri, {
            useNewUrlParser: true,
            useUnifiedTopology: true
        }).then(() => {
            console.log('MongoHelper: inited');
            this.connection = Mongoose.connection;
        });
    }

    static collection(addr: string): Collection {
        return this.connection.collection(addr)
    }

    static deleteAll() {
        let promises: Array<Promise<any>> = [];
        let maxId: number;
        this.collection('id').find<Id>().toArray()
            .then(value => value[0].id)
            .then((value => {
                maxId = value;
                for (let i = 1; i <= value; i++) {
                    promises.push(this.connection.collection(`${i}`).drop().catch(() => {}));
                }
            })).finally(() => {
            Promise.all(promises).finally(() => {
                this.collection('id').findOneAndUpdate({id: maxId}, {$set: {id: 1}})
                    .catch(() => {})
                    .finally(() => console.log('MongoHelper: delete finished'))
            })
        });
    }
}

module.exports = {MongoHelper};
