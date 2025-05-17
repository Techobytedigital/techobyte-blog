# Development <!-- omit in toc -->

Instructions & resources to help with building the site.

## Table of Contents <!-- omit in toc -->

- [Create new post](#create-new-post)
- [Add pages to navigation](#add-pages-to-navigation)
- [Change codefence syntax highlighting theme](#change-codefence-syntax-highlighting-theme)
- [Fix theme install 'already exists' error](#fix-theme-install-already-exists-error)

## Create new post

First, `cd` into the [`site/` directory](./site). Run the command below to generate a new page:

```shell
hugo new posts/pagename.md
```

This will create a new page named `pagename.md` in the [`posts/` directory](./site/content/posts/).

You can also create nested pages:

```shell
hugo new posts/path/to/pagename.md
```

## Add pages to navigation

After [creating a new post or page](./site/content/posts/), you can add it to your site's navigation by editing the [`hugo.toml` configuration file](./site/hugo.toml).

To start, add a section called `[menu]`. Each sub-item in your menu will bein a `[[menu.main]]` section, and you can nest navigation pages using the `parent` property.

For example, to add a page called `Tutorials` to your site, add this to your `hugo.toml`:

```toml
[menu]

# Tutorials page
[[menu.main]]
identifier = "tutorials"
name = "Tutorials"
url = "/posts/tutorials"
weight = 10
```

Then, to add a nested page for `tutorials/wsl`, where posts related to Windows Subsystem for Linux will live, add:

```toml
[menu]

# Tutorials page
[[menu.main]]
identifier = "tutorials"
# The rest of the tutorials/ nav settings
...

# Tutorials/WSL page
[[menu.main]]
identifier = "wsl"
name = "WSL"
url = "/posts/tutorials/wsl"
# The "parent" property nests this menu item beneath the tutorials/ nav item
parent = "tutorials"
weight = 2
```

## Change codefence syntax highlighting theme

Hugo can do [syntax highlighting]() on code fences (```LANG), with [a number of theme options](https://gohugo.io/quick-reference/syntax-highlighting-styles/#styles) to choose from.

[This site](https://xyproto.github.io/splash/docs/all.html) previews the available themes so you can choose the right one for your site.

After deciding on a style, add it to [your `hugo.toml`](./site/hugo.toml)'s `[markup.highlight]` property (you can create this property if it doesn't exist):

```toml
...

## Codefence markup
[markup]
[markup.highlight]
anchorLineNos = true
codeFences = true
guessSyntax = false
hl_Lines = ''
hl_inline = false
lineAnchors = ''
lineNoStart = 1
lineNos = true
lineNumbersInTable = true
noClasses = true
## Options: https://gohugo.io/quick-reference/syntax-highlighting-styles/
#  Generate styles with: hugo gen chromastyles --style=<chosen-style > static/css/syntax.css
style = 'doom-one2'
tabWidth = 4
wrapperClass = 'highlight'

...
```

The example above uses the `doom-one2` style. Once you've selected a theme, you need to generate the `syntax.css` file for it using the `hugo gen chromastyles` command:

```shell
hugo gen chromastyles --style='$THEME_NAME' > path/to/site/static/css/syntax.css
```

*[`hugo gen chromastyles` documentation](https://gohugo.io/commands/hugo_gen_chromastyles/)*

For example, if your site is at [`./site/`](./site), and you want to use the `doom-one2` theme:

```shell
hugo gen chromastyles --style='doom-one2' > site/static/css/syntax.css
```

There is [a script](./scripts/hugo/generate_theme_styles.sh) that can help with generating your styles, just pass the theme name as an arg:

```shell
./scripts/hugo/generate_theme_styles.ssh theme-name
```

## Fix theme install 'already exists' error

When adding a Hugo theme via `git submodule add`, you might get a messsage like:

```shell
fatal: 'site/themes/ThemeName' already exists in the index
```

If you installed a theme and then removed the directory without editing the `.gitmodules` file and removing the theme from your git cache, you will see this error trying to re-install the theme.

To fix it, follow the steps below:

* Remove the theme from your git cache (replace `$THEME_NAME` with the name of the theme causing problems):

```shell
git rm --cache themes/$THEME_NAME
rm -rf .git/modules/themes/$THEME_NAME
```

Then, try re-running your `git submodule add` command.
