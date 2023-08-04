import { Controller } from '@hotwired/stimulus';
import 'chartjs-plugin-datalabels';

export default class extends Controller {
  connect() {
    const funnel = JSON.parse(this.element.dataset.data);

    const fontFamily = 'ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, "Noto Sans", sans-serif, "Apple Color Emoji", "Segoe UI Emoji", "Segoe UI Symbol", "Noto Color Emoji"';
    const labels = funnel.steps.map((step) => step.name);
    const stepData = funnel.steps.map((step) => step.total_events);
    const dropOffData = funnel.steps.map((step) => step.drop_off * 100);

    const data = {
      labels,
      datasets: [
        {
          label: 'Visitors',
          data: stepData,
          borderRadius: 4,
          stack: 'Stack 0',
        },
        {
          label: 'Dropoff',
          data: dropOffData,
          borderRadius: 4,
          stack: 'Stack 0',
        },
      ],
    };

    const config = {
      responsive: true,
      maintainAspectRatio: false,
      plugins: [ChartDataLabels],
      type: 'bar',
      data,
      options: {
        layout: {
          padding: 100,
        },
        plugins: {
          legend: {
            display: false,
          },
          tooltip: {
            mode: 'index',
            intersect: true,
            position: 'average',
          },
          datalabels: {
            anchor: 'end',
            align: 'end',
            borderRadius: 4,
            padding: {
              top: 8, bottom: 8, right: 8, left: 8,
            },
            font: {
              size: 12, weight: 'normal', lineHeight: 1.6, family: fontFamily,
            },
            textAlign: 'center',
          },
        },
        scales: {
          y: { display: false },
          x: {
            position: 'bottom',
            display: true,
            border: { display: false },
            grid: { drawBorder: false, display: false },
            ticks: {
              padding: 8,
              font: { weight: 'bold', family: fontFamily, size: 14 },
              color: 'rgb(228, 228, 231)',
            },
          },
        },
      },
    };

    const visitorsData = [];

    new Chart(
      this.element,
      config,
    );
  }
}
