# Project Aloha Website
> Knowledge record of project aloha uefi and drivers development.

## Introduce
Click [here](https://aloha.firmware.icu/) to jump to our document page.

## How to write and add guide here?
### Repo Introduce 
This repo uses ***VitePress*** to generate static pages.
- Folders:
  + / -> English Guides
  + /zh -> Simplified Chinese Guides
  + /.vitepress -> Site configure
  + /.vscode -> Vscode configuration

### Add a page
  - Open .vitepress/[language].ts, like `en` or `zh`
  - Add new item in `sidebarDocs` under correct sideBar title and has valid path
  - Write guides at correct path, which you just write in `.ts` file.

> [!TIP]
> If your page needs pictures or other small resources(less than 800KB), you can put it at `[GuideClass]/Resources/[NameOfYourGuide]/`

### Local debug
- Install nodejs and insure it's added in PATH.
- Clone this repo and open in vscode.
- Click `Run` in vscode.
Alternatively if you do not want to use vscode:
- Run `npm run docs:dev` at the root of this repo.

### For More
You can read [VitePress's Guides](https://vitepress.dev/guide/getting-started) if you want edit configurations here or want to use some speacial markdown feature provided by vitepress.