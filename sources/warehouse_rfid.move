#[allow(duplicate_alias)]
module pomerene::pomerene {

    use std::string;
    use sui::object::{new, delete, UID};
    use sui::tx_context::{TxContext, sender};
    use sui::transfer::public_transfer;

    /// Represents a pallet with a unique ID
    public struct Pallet has key, store {
        id: UID,
        description: string::String,
        location: string::String,
        data: string::String,
    }

    /// Represents a scanner with a unique ID
    public struct Scanner has key, store {
        id: UID,
        description: string::String,
        location: string::String,
    }


    #[lint_allow(self_transfer)]
    public fun register_scanner(description: string::String, location: string::String, ctx: &mut TxContext) {
        let scanner = Scanner {
            id: new(ctx),
            description,
            location,
        };
        public_transfer(scanner, sender(ctx));
    }

    #[lint_allow(self_transfer)]
    public fun register_pallet(description: string::String, location: string::String, data: string::String, ctx: &mut TxContext) {
        let pallet = Pallet {
            id: new(ctx),
            description,
            location,
            data,
        };
        public_transfer(pallet, sender(ctx));
    }

    public entry fun edit_pallet(pallet: &mut Pallet, description: string::String) {
        pallet.description = description;
       
    }

    // public entry fun delete_scanner(scannerObject: &mut Scanner) {
    //     let Scanner { id, description: _, location: _ } = scannerObject;
    //     object::delete(id);
    // }


    #[allow(unused_field)]
    public entry fun delete_pallet(palletObject: Pallet) {
        let Pallet { id, description: _ ,location: _, data: _,} = palletObject;
        delete(id);
    }
   
}
