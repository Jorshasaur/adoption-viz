import ReactOnRails from 'react-on-rails';

import MapControls from '../bundles/Map/components/MapControls';
import YearSelector from '../bundles/Map/components/YearSelector';
import MapManager from '../bundles/Map/components/MapManager';

// This is how react_on_rails can see the HelloWorld in the browser.
ReactOnRails.register({
  MapControls, YearSelector, MapManager
});
