import React, { useState } from "react";
import { LuMenu } from "react-icons/lu";



interface DrawerProps {
  buttonLabel?: React.ReactNode;
  children: React.ReactNode;
  className?: string;
}


export const Drawer: React.FC<DrawerProps> = ({
  buttonLabel = <LuMenu />,
  children,
  className = "",
}) => {
  const [open, setOpen] = useState(false);

  return (
    <>
      <button className={`btn btn-icon ${className}`} onClick={() => setOpen(true)}>
        {buttonLabel}
      </button>


      {/* Drawer */}
      <div
        className={`
          fixed bg-white dark:bg-surface-800 shadow-lg transition-all duration-300 left-0 top-0 h-screen w-64
          ${open ? "-translate-x-5" : "-translate-x-[100vw]"}
        `}
      >
        <button
          className="absolute top-2 right-2 text-gray-500 hover:text-gray-700"
          onClick={() => setOpen(false)}
          aria-label="Close"
        >
          &times;
        </button>
        <div className="p-4">{children}</div>
      </div>
    </>
  );
};
