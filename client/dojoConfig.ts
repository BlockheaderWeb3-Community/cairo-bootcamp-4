import { createDojoConfig, LOCAL_KATANA, LOCAL_TORII } from "@dojoengine/core";

import manifestRelease from "../contract/manifest_release.json";
import manifestDev from "../contract/manifest_dev.json";

export const dojoConfig = createDojoConfig({
    manifest: manifestDev, // Change to `manifestRelease` for release profile
    toriiUrl: LOCAL_TORII, // Change to your Torii deployment url for release profile
    rpcUrl: LOCAL_KATANA // Change to your Katana deployment url for release profile
});
