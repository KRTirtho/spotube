/* @refresh reload */
import { render } from 'solid-js/web';

import './index.css';
import App from './App';
import { HopeProvider } from '@hope-ui/solid';

render(() => <HopeProvider><App /></HopeProvider>, document.getElementById('root') as HTMLElement);
