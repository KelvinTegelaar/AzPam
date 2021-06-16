import { Component } from '@angular/core';
import { faTachometerAlt, faBullhorn, faInbox, faTasks, faCog, faSignOutAlt } from '@fortawesome/free-solid-svg-icons';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.scss']
})
export class AppComponent {
  faTachometerAlt = faTachometerAlt;
  faBullhorn = faBullhorn;
  faInbox = faInbox;
  faTasks = faTasks;
  faCog = faCog;
  faSignOutAlt = faSignOutAlt;
  title = 'Az PAM';
}
