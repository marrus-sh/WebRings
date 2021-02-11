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
html{ Font: Small / 1.5 Serif }
body{ Display: Grid; Box-Sizing: Border-Box; Margin: 0; Padding: .5REM; Min-Height: 100VH; Text-Align: Center }
#webring>div{ Display: None }
#webring>div:Target{ Display: Flex; Flex-Direction: Column; Width: 100%; Min-Height: 100% }
#webring>div>nav{ Display: Grid; Box-Sizing: Border-Box; Margin: .25REM Auto 0; Border-Style: Double Solid Solid Double; Padding: .25REM; Width: 100%; Grid-Template-Columns: 1FR Max-Content 1FR; Gap: 1.5REM }
#webring>div>nav>*:First-Child{ Text-Align: End }
#webring>div>nav>span{ Border-Right: Medium Dotted; Width: 0; Overflow: Hidden }
#webring>div>nav>*:Last-Child{ Text-Align: Start }
p{ Margin: Auto }
			</html:style>
			<apply-templates mode="clone" select="html:style | html:script"/>
		</copy>
	</template>
	<template match="html:article[@id='webring']">
	<html:article id="webring" lang="en" xml:lang="en">
		<for-each select="document($rdf)//rdf:Seq[@rdf:about = '.']">
			<for-each select="rdf:*[string-length(local-name()) > 1 and starts-with(local-name(), '_') and translate(substring(local-name(), 2, 1), '123456789', '') = '' and translate(substring(local-name(), 3), '0123456789', '') = '']">
				<sort select="substring(local-name(), 2)" data-type="number"/>
					<for-each select="*[@rdf:about]">
		<html:div class="PAGE">
						<if test="rdfs:label">
							<attribute name="id">
								<text>/</text>
								<value-of select="rdfs:label[1]"/>
							</attribute>
						</if>
			<html:p>
				<html:cite>
						<choose>
							<when test="foaf:name">
								<apply-templates select="foaf:name[1]" mode="lang"/>
								<apply-templates select="foaf:name[1]/node()"/>
							</when>
							<otherwise>This website</otherwise>
						</choose>
				</html:cite>
						<text> is a member of </text>
				<html:a href="..">
					<html:cite>
						<apply-templates select="../../foaf:name[1]" mode="lang"/>
						<apply-templates select="../../foaf:name[1]/node()"/>
					</html:cite>
				</html:a>
						<text>.</text>
			</html:p>
			<html:nav>
				<html:a>
					<attribute name="href">
						<choose>
							<when test="../preceding-sibling::rdf:*[string-length(local-name()) > 1 and starts-with(local-name(), '_') and translate(substring(local-name(), 2, 1), '123456789', '') = '' and translate(substring(local-name(), 3), '0123456789', '') = '']">
								<value-of select="../preceding-sibling::rdf:*[string-length(local-name()) > 1 and starts-with(local-name(), '_') and translate(substring(local-name(), 2, 1), '123456789', '') = '' and translate(substring(local-name(), 3), '0123456789', '') = ''][1]/*/@rdf:about[1]"/>
							</when>
							<otherwise>
								<value-of select="../../rdf:*[string-length(local-name()) > 1 and starts-with(local-name(), '_') and translate(substring(local-name(), 2, 1), '123456789', '') = '' and translate(substring(local-name(), 3), '0123456789', '') = ''][last()]/*/@rdf:about[1]"/>
							</otherwise>
						</choose>
					</attribute>
					<text>← Previous page</text>
				</html:a>
				<html:span>
					<text> | </text>
				</html:span>
				<html:a>
					<attribute name="href">
						<choose>
							<when test="../preceding-sibling::rdf:*[string-length(local-name()) > 1 and starts-with(local-name(), '_') and translate(substring(local-name(), 2, 1), '123456789', '') = '' and translate(substring(local-name(), 3), '0123456789', '') = '']">
								<value-of select="../preceding-sibling::rdf:*[string-length(local-name()) > 1 and starts-with(local-name(), '_') and translate(substring(local-name(), 2, 1), '123456789', '') = '' and translate(substring(local-name(), 3), '0123456789', '') = ''][1]/*/@rdf:about[1]"/>
							</when>
							<otherwise>
								<value-of select="../../rdf:*[string-length(local-name()) > 1 and starts-with(local-name(), '_') and translate(substring(local-name(), 2, 1), '123456789', '') = '' and translate(substring(local-name(), 3), '0123456789', '') = ''][last()]/*/@rdf:about[1]"/>
							</otherwise>
						</choose>
					</attribute>
					<text>Next page →</text>
				</html:a>
			</html:nav>
		</html:div>
				</for-each>
			</for-each>
		</for-each>
		<html:script>Array.prototype.forEach.call(document.getElementById("webring").children, $ => $.hidden = !($.id == location.hash.substring(1)))</html:script>
	</html:article>
	</template>
</stylesheet>
