import { Orientation, QMouseEvent } from "@nodegui/nodegui";
import { Slider } from "@nodegui/react-nodegui";
import { CheckBoxProps } from "@nodegui/react-nodegui/dist/components/CheckBox/RNCheckBox";
import React, { useEffect, useState } from "react";

interface SwitchProps extends Omit<CheckBoxProps, "on" |"icon" | "text">{
  onChange?(checked:boolean): void
}

function Switch({ checked, onChange, ...props }: SwitchProps) {
  const [value, setValue] = useState<0|1>(0);

  useEffect(() => {
    setValue(checked ? 1 : 0);
  }, [checked])
  
  return (
    <Slider
      value={value}
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
        MouseButtonRelease(native: any) {
          const mouse = new QMouseEvent(native);
          if (mouse.button() === 1) {
            setValue(value===1?0:1)
          }
        }
      }
      }
      {...props}
    />);
}

export default Switch;
