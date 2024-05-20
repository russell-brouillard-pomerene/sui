#[allow(duplicate_alias)]
module pomerene::pomerene {

    use std::string;
    use sui::object::{Self, UID};
    use sui::tx_context::{Self, TxContext};
    use sui::transfer;
   

    /// Represents a pallet with a unique ID
    public struct Pallet has key, store {
        id: UID,
        description: string::String,
    }

    /// Represents a scanner with a unique ID
    public struct Scanner has key, store {
        id: UID,
        location: string::String,
    }

    /// Represents a scan transaction
    public struct Scan has key, store {
        id: UID,
        scanner_id: UID,
        pallet_id: UID,
        latitude: string::String,
        longitude: string::String,
        timestamp: u64,
    }

    #[lint_allow(self_transfer)]
    public fun register_scanner(location: string::String, ctx: &mut TxContext) {
        let scanner = Scanner {
            id: object::new(ctx),
            location,
        };
        transfer::public_transfer(scanner, tx_context::sender(ctx));
    }

    public entry fun delete_scanner(scannerObject: Scanner) {
        let Scanner { id, location: _ } = scannerObject;
        object::delete(id);
    }

    #[lint_allow(self_transfer)]
    public fun register_pallet(description: string::String, ctx: &mut TxContext) {
        let pallet = Pallet {
            id: object::new(ctx),
            description,
        };
        transfer::public_transfer(pallet, tx_context::sender(ctx));
    }

    public entry fun delete_pallet(palletObject: Pallet) {
        let Pallet { id, description: _ } = palletObject;
        object::delete(id);
    }

    #[lint_allow(self_transfer)]
    public fun scan_pallet(scanner_id: UID, scanner_owner: address, pallet_id: UID, timestamp: u64, latitude: string::String, longitude: string::String, ctx: &mut TxContext) {
        let scan = Scan {
            id: object::new(ctx),
            scanner_id,
            pallet_id,
            latitude,
            longitude,
            timestamp,
        };
        transfer::public_transfer(scan, scanner_owner);
    }
}
