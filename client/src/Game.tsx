import { useEffect, useCallback } from "react";
import { WalletAccount } from "./wallet-account";
import {
    useDojoSDK,
    useEntityId,
    useEntityQuery,
    useModel,
} from "@dojoengine/sdk/react";
import { KeysClause, ToriiQueryBuilder } from "@dojoengine/sdk";
import { ModelsMapping } from "./typescript/models.gen";
import { addAddressPadding, CairoCustomEnum } from "starknet";
import { useAccount } from "@starknet-react/core";

const GRID_SIZE = 8;
const CELL_SIZE_PX = 40; // Size of each cell in pixels for visualization

function Game() {
    const { client } = useDojoSDK();
    const { account } = useAccount();
    const entityId = useEntityId(account?.address ?? "0");

    const player = useModel(entityId as string, ModelsMapping.Player);
    const position = useModel(entityId as string, ModelsMapping.Position);

    const handleKeyDown = useCallback(
        async (event: any) => {
            let direction;

            // Calculate new position based on key press
            switch (event.key) {
                case "ArrowUp":
                    direction = new CairoCustomEnum({
                        Up: "()",
                    });
                    break;
                case "ArrowDown":
                    direction = new CairoCustomEnum({
                        Down: "()",
                    });
                    break;
                case "ArrowLeft":
                    direction = new CairoCustomEnum({
                        Left: "()",
                    });
                    break;
                case "ArrowRight":
                    direction = new CairoCustomEnum({
                        Right: "()",
                    });
                    break;
                default:
                    return;
            }

            await client.actions.move(account, direction);
        },
        [player, position]
    );

    useEntityQuery(
        new ToriiQueryBuilder()
            .withClause(
                // Querying Moves and Position models that has at least [account.address] as key
                KeysClause(
                    [ModelsMapping.Player, ModelsMapping.Position],
                    [
                        account?.address
                            ? addAddressPadding(account.address)
                            : undefined,
                    ],
                    "FixedLen"
                ).build()
            )
            .includeHashedKeys()
    );

    useEffect(() => {
        window.addEventListener("keydown", handleKeyDown);

        return () => {
            window.removeEventListener("keydown", handleKeyDown);
        };
    }, [handleKeyDown]);

    // Render the grid
    const renderGrid = () => {
        const cells = [];
        for (let y = 0; y < GRID_SIZE; y++) {
            for (let x = 0; x < GRID_SIZE; x++) {
                const isPlayer = position?.vec.x === x && position?.vec.y === y;
                const isBag =
                    player?.next_bag.x === x && player?.next_bag.y === y;
                // Base cell style for dark mode
                let cellClass =
                    "border border-gray-600 flex items-center justify-center";
                let content = "";

                // Apply styles based on whether it's the player, bag, or empty
                if (isPlayer) {
                    // Player style (blue circle, contrasts well on dark)
                    cellClass += " bg-blue-500 rounded-full";
                } else if (isBag) {
                    // Bag style (yellow square for coins)
                    cellClass += " bg-yellow-500 rounded-md";
                    content = "💰"; // Emoji for bag of coins
                } else {
                    // Empty cell style for dark mode
                    cellClass += " bg-gray-700";
                }

                cells.push(
                    <div
                        key={`${x}-${y}`}
                        className={cellClass}
                        style={{
                            width: `${CELL_SIZE_PX}px`,
                            height: `${CELL_SIZE_PX}px`,
                        }}
                    >
                        {/* Text size for emoji */}
                        <span className="text-xl">{content}</span>
                    </div>
                );
            }
        }
        return cells;
    };

    return (
        <div className="flex flex-col items-center justify-center min-h-screen bg-gray-900 p-4 font-sans">
            <div className="flex  gap-2">
                <WalletAccount />
                {account && (
                    <button
                        onClick={async () => {
                            await client.actions.spawn(account);
                        }}
                        className="text-white border border-white p-3 h-fit"
                    >
                        Spawn
                    </button>
                )}
            </div>

            <h1 className="text-2xl font-bold mb-4 text-gray-100">
                Chase the Bag
            </h1>
            <p className="mb-4 text-gray-300">
                Use arrow keys to move the blue circle (player) to the bag of
                coins (💰).
            </p>
            <div
                className="grid border border-gray-500 bg-gray-800 shadow-lg rounded-lg overflow-hidden"
                style={{
                    gridTemplateColumns: `repeat(${GRID_SIZE}, ${CELL_SIZE_PX}px)`,
                    gridTemplateRows: `repeat(${GRID_SIZE}, ${CELL_SIZE_PX}px)`,
                    width: `${GRID_SIZE * CELL_SIZE_PX}px`, // Set fixed width
                    height: `${GRID_SIZE * CELL_SIZE_PX}px`, // Set fixed height
                }}
                tabIndex={0}
            >
                {renderGrid()}
            </div>
            <p className="mt-4 text-sm text-gray-400">
                Player Position: ({position?.vec.x}, {position?.vec.y}) | Bag
                Position: ({player?.next_bag.x}, {player?.next_bag.y}) | Score ({parseInt(player?.score ?? 0)})
            </p>
        </div>
    );
}

export default Game;
