<!--
§ Usage:

Stick the following at the beginning of your XML file:

```
<?xml-stylesheet type="text/xsl" href="/path/to/transform.xslt"?>
```

§§ Configuration (in the file which links to this stylesheet):

☞ The first ‹ <html:link rel="alternate" type="application/rdf+xml"> › element with an @href attribute is used to source the RDF for the corpus.
☞ Exactly one ‹ <html:article id="webring"> › must be supplied; the result of the transform will be placed in here!
☞ Feel free to add your own <html:style> elements or other content.
-->
<stylesheet
	id="transform"
	version="1.0"
	xmlns="http://www.w3.org/1999/XSL/Transform"
	xmlns:foaf="http://xmlns.com/foaf/0.1/"
	xmlns:html="http://www.w3.org/1999/xhtml"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
>
	<variable name="rdf" select="//html:link[@rel='alternate'][@type='application/rdf+xml']/@href[1]"/>
	<template match="@*|node()" mode="clone">
		<copy>
			<apply-templates mode="clone" select="@*|node()"/>
		</copy>
	</template>
	<template match="*" mode="lang">
		<attribute name="lang">
			<value-of select="ancestor-or-self::*[@xml:lang][1]/@xml:lang"/>
		</attribute>
		<attribute name="xml:lang">
			<value-of select="ancestor-or-self::*[@xml:lang][1]/@xml:lang"/>
		</attribute>
	</template>
	<template match="*">
		<copy>
			<apply-templates mode="clone" select="@*"/>
			<apply-templates/>
		</copy>
	</template>
	<template match="html:head">
		<!-- the content from the head of the document is simply copied over, with an additional stylesheet added.  the original styles and scripts are moved to the end, following the added stylesheet, so that they will take precedence. -->
		<copy>
			<apply-templates mode="clone" select="@* | node()[namespace-uri() != 'http://www.w3.org/1999/xhtml'] | html:*[local-name() != 'style' and local-name() != 'script']"/>
			<html:style>
@namespace "http://www.w3.org/1999/xhtml";

/* Root */
html{ Font: Medium / 1.5 Serif }
body{ Margin: 0; Padding: 1.5REM 1REM 6REM }

/* The WebRing Index */
nav{ Box-Sizing: Border-Box; Margin: Auto; Width: 100%; Max-Width: 27REM }
nav>ol{ All: Unset; Display: Grid; Margin: Auto; Max-Width: Max-Content; Grid: Auto-Flow / Max-Content 1FR Min-Content Max-Content; Gap: 1EM 1.4EM }
nav>ol>li{ Display: Contents }
nav>ol>li::before{ Display: Grid; Box-Sizing: Border-Box; Margin-Right: -.5EM; Border-Right: 2PX Solid; Padding: .5EM .5EM .5EM 0; Height: 100%; Align-Items: Center; Font-Style: Italic; Text-Align: Right; Content: Attr(value) ":" }
nav>ol>li>dl{ Display:Contents }
nav>ol>li>dl::after{ Align-Self: End; Font-Size: Smaller; Font-Family: Monospace; Line-Height: 1; Text-Align: Right; Content: "[" Attr(id) "]" }
nav>ol>li>dl>div{ Display: Flex; Flex-Direction: Column; Text-Align: Center }
nav>ol>li>dl>div:Nth-Child(Even){ Grid-Column: 3 }
nav>ol>li>dl>div:Nth-Child(Odd){ Grid-Column: 2 }
nav>ol>li>dl>div:Nth-Child(Odd)>dd cite{ Font-Size: Larger; Font-Style: Inherit; Text-Decoration: None }

/* Blocks */
div[property="rdfs:comment"]{ Margin: 1.5REM Auto; Max-Width: 27REM; White-Space: Pre-Wrap; Text-Align: Justify }
div[property="rdfs:comment"]>*{ White-Space: Normal }
dt{ All: Unset; Display: Block; Font-Size: Smaller; Font-Weight: Bold; Font-Style: Italic; Line-Height: 1 }
dd{ All: Unset; Margin: Auto }
h1,
h2{ Margin: 1.5REM Auto 1.5REM; Font-Size: 1.5REM; Text-Align: Center }
h1{ Border-Bottom: Thick Double; Padding: 0 0 1.5REM; Font-Style: Italic; Font-Weight: Bold }
h2{ Border-Bottom: Thin Solid; Padding: 0 .5EM; Max-Width: Max-Content; Font-Weight: Inherit; Font-Variant-Caps: Small-Caps; Letter-Spacing: Calc(1EM / 24) }
div[property="rdfs:comment"] h1,
div[property="rdfs:comment"] h2{ Margin-Bottom: .75REM; Border-Bottom: 2PX Solid; Padding: None; Max-Width: Max-Content; Font: Inherit; Letter-Spacing: Calc(1EM / 24); Text-Transform: Uppercase }
ol,
ul{ Margin: .75EM 0 }
p{ Margin: 0 }
p+p{ Text-Indent: 1.5EM }
pre{ Margin: .75EM 0; Padding-Left: 1.5EM; Text-Align: Start; Text-Indent: -1.5EM }
pre>code{ White-Space: Pre-Line }
li>p:First-Child{ Margin-Top: .75EM }

/* Inlines */
u{ Font-Variant-Caps: Small-Caps; Text-Decoration: None }
			</html:style>
			<apply-templates mode="clone" select="html:style | html:script"/>
		</copy>
	</template>
	<template match="html:article[@id='webring']">
	<html:article id="webring" lang="en" xml:lang="en" prefix="rdf: http://www.w3.org/1999/02/22-rdf-syntax-ns# rdfs: http://www.w3.org/2000/01/rdf-schema#" resource="." typeof="rdf:Seq" vocab="http://xmlns.com/foaf/0.1/">
		<for-each select="document($rdf)//rdf:Seq[@rdf:about = '.']">
		<html:section>
			<if test="rdfs:label">
				<attribute name="id">
					<value-of select="rdfs:label[1]"/>
				</attribute>
			</if>
			<html:h1>
			<apply-templates select="foaf:name[1]" mode="lang"/>
			<apply-templates select="foaf:name[1]/node()"/>
			</html:h1>
			<if test="rdfs:comment">
				<for-each select="rdfs:comment">
			<html:div property="rdfs:comment">
					<apply-templates select="." mode="lang"/>
					<apply-templates/>
			</html:div>
				</for-each>
			</if>
			<html:nav>
				<html:h2>WebRing Index</html:h2>
					<html:ol>
			<for-each select="rdf:*[string-length(local-name()) > 1 and starts-with(local-name(), '_') and translate(substring(local-name(), 2, 1), '123456789', '') = '' and translate(substring(local-name(), 3), '0123456789', '') = '']">
				<sort select="substring(local-name(), 2)" data-type="number"/>
						<html:li value="{substring(local-name(), 2)}">
					<for-each select="*[@rdf:about]">
							<html:dl property="rdf:{local-name(..)}" resource="{@rdf:about}">
						<if test="rdfs:label">
							<attribute name="id">
								<value-of select="rdfs:label[1]"/>
							</attribute>
						</if>
								<html:div>
									<html:dt>Website Name</html:dt>
									<html:dd>
										<html:a href="{@rdf:about}">
						<choose>
							<when test="foaf:name">
											<html:cite property="foaf:name">
								<apply-templates select="foaf:name[1]" mode="lang"/>
								<apply-templates select="foaf:name[1]/node()"/>
											</html:cite>
							</when>
							<otherwise>
								<value-of select="@rdf:about"/>
							</otherwise>
						</choose>
										</html:a>
									</html:dd>
								</html:div>
						<if test="foaf:maker">
								<html:div>
									<html:dt>
							<text>Author</text>
							<if test="count(foaf:maker) > 1">
								<text>s</text>
							</if>
									</html:dt>
							<for-each select="foaf:maker/*">
									<html:dd>
								<choose>
									<when test="@rdf:about">
										<html:a href="{@rdf:about}" property="foaf:maker" resource="{@rdf:about}">
											<html:u property="foaf:name">
										<apply-templates select="foaf:name[1]" mode="lang"/>
										<apply-templates select="foaf:name[1]/node()"/>
											</html:u>
										</html:a>
									</when>
									<otherwise>
										<apply-templates select="foaf:name/node()"/>
									</otherwise>
								</choose>
									</html:dd>
							</for-each>
								</html:div>
						</if>
							</html:dl>
					</for-each>
						</html:li>
				</for-each>
					</html:ol>
				</html:nav>
			</html:section>
			</for-each>
	</html:article>
	</template>
</stylesheet>
