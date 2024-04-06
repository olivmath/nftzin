import { ReactNode } from "react";
import { ConnectButton } from "@rainbow-me/rainbowkit";

type LayoutProps = {
  children: ReactNode;
};

const Layout = ({ children }: LayoutProps) => (
  <>
    <div style={{ display: "flex", justifyContent: "flex-end", padding: 12 }}>
      <ConnectButton />
    </div>
    {children}
  </>
);

export default Layout;
