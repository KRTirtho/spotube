import { Orientation, QMouseEvent } from "@nodegui/nodegui";
import { Slider } from "@nodegui/react-nodegui";
import { CheckBoxProps } from "@nodegui/react-nodegui/dist/components/CheckBox/RNCheckBox";
import React, { useEffect, useState } from "react";

export interface SwitchProps extends Omit<CheckBoxProps, "on" | "icon" | "text"> {
    onChange?(checked: boolean): void;
}

function Switch({ checked: derivedChecked, onChange, ...props }: SwitchProps) {
    const [checked, setChecked] = useState<boolean>(false);

    useEffect(() => {
        if (derivedChecked) {
            setChecked(derivedChecked);
        }
    }, []);

    return (
        <Slider
            value={checked ? 1 : 0}
            hasTracking
            mouseTracking
            orientation={Orientation.Horizontal}
            maximum={1}
            minimum={0}
            maxSize={{ width: 30, height: 20 }}
            on={{
                valueChanged(value) {
                    onChange && onChange(value === 1);
                },
                // eslint-disable-next-line @typescript-eslint/no-explicit-any
                MouseButtonRelease(native: any) {
                    const mouse = new QMouseEvent(native);
                    if (mouse.button() === 1) {
                        setChecked(!checked);
                    }
                },
            }}
            {...props}
        />
    );
}

export default Switch;
