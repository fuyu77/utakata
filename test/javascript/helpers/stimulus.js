import { Application } from '@hotwired/stimulus';

export async function startStimulus(identifier, controllerClass) {
  const application = Application.start();
  application.register(identifier, controllerClass);
  await new Promise((resolve) => setTimeout(resolve, 0));

  const element = document.querySelector(`[data-controller~="${identifier}"]`);
  const controller = application.getControllerForElementAndIdentifier(
    element,
    identifier,
  );

  return { application, controller, element };
}
