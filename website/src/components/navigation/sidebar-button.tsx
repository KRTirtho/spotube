import { useRef, useState } from "react";
import { LuMenu } from "react-icons/lu";
import { useOnClickOutside } from "usehooks-ts";
import { routes } from "~/collections/app";

export default function SidebarButton() {
  const ref = useRef<HTMLDivElement>(null)
  const [isOpen, setIsOpen] = useState(false);

  useOnClickOutside(ref as React.RefObject<HTMLDivElement>, () => {
    setIsOpen(false);
  })

  return <>
    <div className={
      `fixed h-screen w-72 bg-surface-100 dark:bg-surface-900 top-0 left-0 bg-surface z-50 transition-all duration-300 ${isOpen ? "" : "-translate-x-full"}`
    }
      ref={ref}
    >
      {
        Object.entries(routes).map((route) => {
          const Icon = route[1][1];
          return (
            <a
              key={route[0]}
              href={route[0]}
              className="flex items-center gap-2 p-4 hover:bg-surface/80 transition-colors duration-200"
            >
              {Icon && <Icon />}
              <span className="text-lg">{route[1][0]}</span>
            </a>
          )
        })
      }
    </div>
    <button
      className="btn btn-icon md:hidden"
      onClick={() => {
        setIsOpen(!isOpen);
      }}
    >
      <LuMenu />
    </button>
  </>;
}