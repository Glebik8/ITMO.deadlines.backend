import * as mongoose from "mongoose";
import * as Mongoose from "mongoose";
import {Collection} from "mongoose";

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
}
