"use client";

import * as Dialog from "@radix-ui/react-dialog";
import { X, UserCircle2 } from "lucide-react";
import { useState } from "react";
import { useConnect, useAccount, Connector, useDisconnect } from "@starknet-react/core";

export default function Navbar() {
  const [isOpen, setIsOpen] = useState(false);

  const { connectors, connect, connectAsync } = useConnect();

  const { account, address, isConnected } = useAccount();


  const handleConnect = async (connector: Connector) => {
    await connectAsync({ connector });
    setIsOpen(false);
  };

  return (
    <nav className="w-full border border-[#1c1f26] px-6 py-4">
      <div className="flex items-center justify-between">
        <h1 className="text-3xl font-extrabold text-center mb-10 leading-snug">
          <span className="bg-gradient-to-r from-[#5C94FF] to-[#FC8181] bg-clip-text text-transparent">
            Blockheaderweb3
          </span>
        </h1>

        {isConnected && account ? (
          <ProfileBar address={account.address} />
        ) : (
          <button
            onClick={() => setIsOpen(true)}
            className="px-4 md:px-4 py-3 text-base md:text-lg font-bold bg-gradient-to-r from-[#FC8181] to-[#5C94FF] rounded-full hover:opacity-90 transition-all duration-200"
          >
            Connect Wallet
          </button>
        )}
      </div>

      <Dialog.Root open={isOpen} onOpenChange={() => setIsOpen(!isOpen)}>
        <Dialog.Portal>
          <Dialog.Overlay className="fixed inset-0 bg-black/60 z-40" />
          <Dialog.Content className="fixed z-50 top-1/2 left-1/2 w-[90vw] max-w-md -translate-x-1/2 -translate-y-1/2 rounded-2xl bg-background p-6 shadow-xl border border-[#1c1f26]">
            <div className="flex items-center justify-between mb-4">
              <Dialog.Title className="text-xl font-bold text-foreground">
                Connect Wallet
              </Dialog.Title>
              <Dialog.Close asChild>
                <button className="text-foreground hover:text-red-500">
                  <X />
                </button>
              </Dialog.Close>
            </div>

            <p className="text-sm text-muted-foreground mb-4">
              Choose a wallet to continue.
            </p>

            <div className="space-y-3">
              {connectors.map((connector) => (
                <button
                  onClick={() => handleConnect(connector)}
                  className="w-full py-2 rounded-md bg-[#5C94FF] text-white font-semibold hover:bg-[#487dd8] transition"
                >
                  {connector.name}
                </button>
              ))}
            </div>
          </Dialog.Content>
        </Dialog.Portal>
      </Dialog.Root>
    </nav>
  );
}

function ProfileBar({ address }: { address: string }) {
  const {disconnect} = useDisconnect()

  // Helper function to truncate the address
  const truncateAddress = (addr: string) => {
    return `${addr.slice(0, 6)}...${addr.slice(-4)}`;
  };

  return (
    <div className="flex items-center space-x-2 px-4 py-2 rounded-full border border-[#2d2f36] bg-[#1c1f26]">
      <UserCircle2 className="w-6 h-6 text-white" />
      <span className="text-white text-sm font-medium">{truncateAddress(address)}</span>
      <button
        onClick={() => disconnect()}
        className="text-red-500 hover:underline text-sm font-medium"
      >
        Disconnect
      </button>
    </div>
  );
}
