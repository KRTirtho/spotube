import React, { useEffect, useRef } from "react";
import { QGraphicsDropShadowEffect, QPushButton } from "@nodegui/nodegui";
import { Button } from "@nodegui/react-nodegui";
import { ButtonProps } from "@nodegui/react-nodegui/dist/components/Button/RNButton";

type IconButtonProps = Omit<ButtonProps, "text">;

function IconButton({ style, ...props }: IconButtonProps) {
    const iconBtnRef = useRef<QPushButton>();
    const shadowGfx = new QGraphicsDropShadowEffect();
    useEffect(() => {
        shadowGfx.setBlurRadius(5);
        shadowGfx.setXOffset(0);
        shadowGfx.setYOffset(0);
        iconBtnRef.current?.setGraphicsEffect(shadowGfx);
    }, []);
    const iconButtonStyleSheet = `
    #icon-btn{
       background-color: rgba(255, 255, 255, 0.055);
       border-width: 1px;
       border-style: solid;
       border-color: transparent;
       border-radius: ${((props.maxSize ?? props.size)?.width ?? 30) / 2}px; 
       ${style ?? ``}
    }
    #icon-btn:hover{
      border-color: green;
    }
    #icon-btn:pressed{
      border-style: groove;
      background-color: #1cca1c;
    }
  `;

    return (
        <Button
            ref={iconBtnRef}
            id="icon-btn"
            size={{ height: 30, width: 30, fixed: true }}
            styleSheet={iconButtonStyleSheet}
            {...props}
        />
    );
}

export default IconButton;
