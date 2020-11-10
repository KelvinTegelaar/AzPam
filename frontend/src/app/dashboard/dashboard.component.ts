import { Component, OnInit } from '@angular/core';
import { faRandom, faUser, faCheckCircle } from '@fortawesome/free-solid-svg-icons';

@Component({
  selector: 'app-dashboard',
  templateUrl: './dashboard.component.html',
  styleUrls: ['./dashboard.component.scss']
})
export class DashboardComponent implements OnInit {
  faRandom = faRandom;
  faUser = faUser;
  faCheckCircle = faCheckCircle;

  constructor() { }

  ngOnInit(): void {
  }

}
