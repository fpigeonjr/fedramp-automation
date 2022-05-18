<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    exclude-result-prefixes="xs math oscal"
    expand-text="true"
    version="3.0"
    xmlns:fn="local-function"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:oscal="http://csrc.nist.gov/ns/oscal/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">

    <xsl:param
        as="xs:anyURI"
        name="catalog5-uri"
        required="true" />

    <xsl:param
        as="xs:anyURI"
        name="profile5l-uri"
        required="true" />

    <xsl:param
        as="xs:anyURI"
        name="profile5m-uri"
        required="true" />

    <xsl:param
        as="xs:anyURI"
        name="profile5h-uri"
        required="true" />

    <xsl:param
        as="xs:anyURI"
        name="catalog4-uri"
        required="true" />

    <xsl:param
        as="xs:anyURI"
        name="profile4l-uri"
        required="true" />

    <xsl:param
        as="xs:anyURI"
        name="profile4m-uri"
        required="true" />

    <xsl:param
        as="xs:anyURI"
        name="profile4h-uri"
        required="true" />

    <xsl:param
        as="xs:anyURI"
        name="odp-mapping-uri"
        required="true" />
    
    <xsl:param name="fedramp-baseline4h-uri" as="xs:anyURI" required="true"></xsl:param>

    <xsl:param
        as="xs:boolean"
        name="show-ODP-id"
        required="false"
        select="true()" />

    <xsl:function
        as="xs:boolean"
        name="fn:novel-ODP">
        <xsl:param
            as="xs:string"
            name="param-id"
            required="true" />
        <xsl:sequence
            select="xs:boolean($param-id = $odp-mapping//*:param-map[@novel]/@rev5-id)" />
    </xsl:function>

    <xsl:variable
        as="document-node()"
        name="catalog5"
        select="doc($catalog5-uri)" />

    <xsl:variable
        as="document-node()"
        name="profile5l"
        select="doc($profile5l-uri)" />

    <xsl:variable
        as="document-node()"
        name="profile5m"
        select="doc($profile5m-uri)" />

    <xsl:variable
        as="document-node()"
        name="profile5h"
        select="doc($profile5h-uri)" />

    <xsl:variable
        as="document-node()"
        name="catalog4"
        select="doc($catalog4-uri)" />

    <xsl:variable
        as="document-node()"
        name="profile4l"
        select="doc($profile4l-uri)" />

    <xsl:variable
        as="document-node()"
        name="profile4m"
        select="doc($profile4m-uri)" />

    <xsl:variable
        as="document-node()"
        name="profile4h"
        select="doc($profile4h-uri)" />

    <xsl:variable
        as="document-node()"
        name="odp-mapping"
        select="doc($odp-mapping-uri)" />

    <xsl:variable
        as="document-node()"
        name="fedramp-baseline4h"
        select="doc($fedramp-baseline4h-uri)" />
    
    <xsl:mode
        on-no-match="shallow-skip" />

    <xsl:output
        include-content-type="false"
        method="html"
        version="5.0" />

    <xsl:variable
        as="xs:string*"
        name="blc5"
        select="distinct-values(($profile5l//with-id, $profile5m//with-id, $profile5h//with-id))" />

    <xsl:variable
        as="xs:string*"
        name="blc4"
        select="distinct-values(($profile4l//with-id, $profile4m//with-id, $profile4h//with-id))" />

    <xsl:variable
        as="xs:string*"
        name="c5wt"
        select="sort(distinct-values($catalog5//control[@id = $blc4][prop[@name eq 'status' and @value eq 'withdrawn']]/link/@href ! replace(., '^#', '')))" />

    <xsl:template
        match="/">
        <!--<xsl:message> {$c5wt} </xsl:message>-->
        <html>
            <head>
                <title>ODP Comparison</title>

                <meta
                    content="text/html; charset=UTF-8"
                    http-equiv="Content-Type" />

                <xsl:variable
                    name="css"
                    select="unparsed-text(replace(static-base-uri(), '\.xsl$', '.css'))" />
                <style><xsl:value-of disable-output-escaping="true" select="replace($css, '\s+', ' ')" /></style>

            </head>

            <body>


                <xsl:for-each
                    select="$blc4">
                    <xsl:choose>
                        <xsl:when
                            test="current() = $catalog5//control[not(prop[@name eq status and @value eq 'withdrawn'])]/@id"> </xsl:when>
                        <xsl:otherwise>
                            <div>{.}</div>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each>

                <div>Renamed control titles are <span
                        class="renamed">italicized</span>.</div>
                <div>Withdrawn controls appear <span
                        class="withdrawn">thus</span>.</div>
                <div>Revision 4 controls are denoted by ④.</div>
                <div>Revision 5 controls are denoted by ⑤.</div>
                <div>Control employment in Low, Moderate, and High baselines is respectively denoted by Ⓛ, Ⓜ, and Ⓗ.</div>

                <table>

                    <colgroup>
                        <col
                            style="width: 25%;" />
                        <col
                            style="width: 75%;" />
                    </colgroup>

                    <thead />

                    <tbody>
                        <xsl:apply-templates
                            select="$catalog5/catalog" />
                    </tbody>

                </table>

            </body>
        </html>
    </xsl:template>

    <xsl:template
        match="group[@class eq 'family']">
        <tr
            id="{@id}">
            <th
                class="family"
                colspan="2">{title} Family</th>
        </tr>
        <tr>
            <th>SP 800-53 Control</th>
            <th>ODPs</th>
        </tr>
        <xsl:apply-templates
            select="descendant::control[@id = $blc5 or @id = $blc4 or @id = $c5wt]">
            <xsl:sort
                select="prop[@name eq 'sort-id']/@value" />
        </xsl:apply-templates>
    </xsl:template>

    <xsl:template
        match="control">

        <xsl:variable
            as="xs:ID"
            name="control-id-5"
            select="current()/@id" />

        <xsl:variable
            as="element()"
            name="control5"
            select="current()" />

        <xsl:variable
            as="element()*"
            name="control4"
            select="$catalog4//control[@id eq $control-id-5]" />

        <tr>

            <xsl:variable
                as="xs:integer"
                name="p5"
                select="count($control5/param)" />
            <xsl:variable
                as="xs:integer"
                name="p4"
                select="
                    if (exists($control4)) then
                        count($control4/param)
                    else
                        0" />

            <td>

                <!-- rev4 -->
                <xsl:choose>
                    <xsl:when
                        test="exists($control4) and $control4/@id = $blc4">
                        <div>
                            <xsl:if
                                test="$control4/prop[@name eq 'status' and @value eq 'withdrawn']">
                                <xsl:attribute
                                    name="class">withdrawn</xsl:attribute>
                            </xsl:if>
                            <xsl:text>④ {$control4/prop[@name="label"]/@value, $control4/title}</xsl:text>
                            <xsl:if
                                test="$profile4l//with-id[. eq $control-id-5]">
                                <xsl:text> Ⓛ</xsl:text>
                            </xsl:if>
                            <xsl:if
                                test="$profile4m//with-id[. eq $control-id-5]">
                                <xsl:text> Ⓜ</xsl:text>
                            </xsl:if>
                            <xsl:if
                                test="$profile4h//with-id[. eq $control-id-5]">
                                <xsl:text> Ⓗ</xsl:text>
                            </xsl:if>
                        </div>
                    </xsl:when>
                    <xsl:when
                        test="not(exists($control4))">
                        <xsl:text>④ did not use control {$control5/prop[@name eq 'label']/@value} because control was not present until rev5.</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:message>{$control4/@id} vs {$control5/@id}, exists4={exists($catalog4//control[@id eq $control-id-5])}, in
                            blc4={$control4/@id = $blc4}</xsl:message>
                        <span
                            class="not4">④</span>
                        <xsl:text> {$control5/prop[@name eq 'label']/@value} is a replacement</xsl:text>
                        <xsl:variable
                            as="xs:string"
                            name="r"
                            select="concat('#', $control-id-5)" />
                        <xsl:text> for {$catalog5//control[link[@href eq concat('#', $control-id-5)]]/prop[@name eq 'label']/@value} which was used in rev4 and withdrawn in rev5.</xsl:text>
                        <xsl:message
                            select="$r" />
                    </xsl:otherwise>
                </xsl:choose>

                <!-- rev5 -->
                <div
                    id="{$control5/@id}">
                    <xsl:variable
                        as="xs:boolean"
                        name="withdrawn"
                        select="exists($control5/prop[@name eq 'status' and @value eq 'withdrawn'])" />

                    <span>
                        <xsl:if
                            test="$withdrawn">
                            <xsl:attribute
                                name="class">withdrawn</xsl:attribute>
                        </xsl:if>
                        <xsl:text>⑤ {$control5/prop[@name="label"]/@value} </xsl:text>
                        <span>
                            <xsl:if
                                test="$control5/title ne $control4/title">
                                <xsl:attribute
                                    name="class">renamed</xsl:attribute>
                            </xsl:if>
                            <xsl:text>{$control5/title}</xsl:text>
                        </span>
                        <span>
                            <xsl:if
                                test="$profile5l//with-id[. eq $control-id-5]">
                                <xsl:text> Ⓛ</xsl:text>
                            </xsl:if>
                            <xsl:if
                                test="$profile5m//with-id[. eq $control-id-5]">
                                <xsl:text> Ⓜ</xsl:text>
                            </xsl:if>
                            <xsl:if
                                test="$profile5h//with-id[. eq $control-id-5]">
                                <xsl:text> Ⓗ</xsl:text>
                            </xsl:if>
                        </span>
                    </span>
                    <xsl:if
                        test="$withdrawn">

                        <span
                            class="smaller">
                            <xsl:text> - WITHDRAWN</xsl:text>
                        </span>
                        <xsl:for-each
                            select="$control5/link">
                            <div
                                class="smaller">
                                <xsl:choose>
                                    <xsl:when
                                        test="@rel eq 'incorporated-into'">
                                        <xsl:text>Incorporated into </xsl:text>
                                        <xsl:choose>
                                            <xsl:when
                                                test="matches(@href, 'smt')">
                                                <a
                                                    href="{@href}">{@href ! replace(., '^#', '') ! upper-case(.) ! replace(., '\.(.+$)', '($1)')}</a>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <a
                                                    href="{@href}">{@href ! replace(., '^#', '') ! upper-case(.) ! replace(., '\.(.+$)', '($1)')}</a>
                                            </xsl:otherwise>
                                        </xsl:choose>

                                    </xsl:when>
                                    <xsl:when
                                        test="@rel eq 'moved-to'">
                                        <xsl:text>Moved to </xsl:text>
                                        <a
                                            href="{@href}">{@href ! replace(., '^#', '') ! upper-case(.) ! replace(., '\.(.+$)', '($1)')}</a>
                                    </xsl:when>
                                </xsl:choose>
                                <xsl:if
                                    test="
                                        (: this control is not in any rev5 baseline :)
                                        not(@href ! replace(., '^#', '') = $blc5)">
                                    <span>
                                        <xsl:text> </xsl:text>
                                        <strong>which is not in any rev5 baseline</strong>
                                    </span>
                                </xsl:if>
                            </div>
                        </xsl:for-each>

                    </xsl:if>

                </div>

                <xsl:apply-templates
                    mode="statement"
                    select="$control5/part[@name eq 'statement']" />
                
                <xsl:if test="$fedramp-baseline4h//alter[@control-id eq $control5/@id]">
                    <xsl:message>alteration at {$control5/@id}</xsl:message>
                </xsl:if>

            </td>

            <xsl:choose>

                <xsl:when
                    test="count($control5/param) eq 0">
                    <td>No ODPs</td>
                </xsl:when>

                <xsl:otherwise>
                    <td>
                        <xsl:for-each
                            select="$control5/param">
                            <xsl:variable
                                as="element()"
                                name="odpm"
                                select="$odp-mapping//*:param-map[@rev5-id eq current()/@id]" />
                            <div>
                                <span>⑤ </span>
                                <span
                                    class="identifier">{./@id}</span>
                                <span> {.}</span>
                                <xsl:if
                                    test="$odpm/@rev4-id">
                                    <span> ⇐ ④ </span>
                                    <span
                                        class="identifier">{$odpm/@rev4-id}</span>
                                    <xsl:if
                                        test="
                                            (: there is at least one baseline constraint :)
                                            some $p in ($profile4l, $profile4m, $profile4h)
                                                satisfies exists($p//set-parameter[@param-id eq $odpm/@rev4-id]/constraint)">
                                        <span>
                                            <details
                                                class="constraints">
                                                <summary>constraints</summary>
                                                <div>
                                                    <xsl:text>Ⓛ </xsl:text>
                                                    <xsl:choose>
                                                        <xsl:when
                                                            test="
                                                                exists($profile4l//set-parameter[@param-id eq $odpm/@rev4-id]/constraint)">
                                                            <xsl:text>{$profile4l//set-parameter[@param-id eq $odpm/@rev4-id]/constraint}</xsl:text>
                                                        </xsl:when>
                                                        <xsl:otherwise>
                                                            <xsl:text>Not constrained.</xsl:text>
                                                        </xsl:otherwise>
                                                    </xsl:choose>
                                                </div>
                                                <div>
                                                    <xsl:text>Ⓜ </xsl:text>
                                                    <xsl:choose>
                                                        <xsl:when
                                                            test="
                                                                exists($profile4m//set-parameter[@param-id eq $odpm/@rev4-id]/constraint)">
                                                            <xsl:text>{$profile4m//set-parameter[@param-id eq $odpm/@rev4-id]/constraint}</xsl:text>
                                                        </xsl:when>
                                                        <xsl:otherwise>
                                                            <xsl:text>Not constrained.</xsl:text>
                                                        </xsl:otherwise>
                                                    </xsl:choose>
                                                </div>
                                                <div>
                                                    <xsl:text>Ⓗ </xsl:text>
                                                    <xsl:choose>
                                                        <xsl:when
                                                            test="
                                                                exists($profile4h//set-parameter[@param-id eq $odpm/@rev4-id]/constraint)">
                                                            <xsl:text>{$profile4h//set-parameter[@param-id eq $odpm/@rev4-id]/constraint}</xsl:text>
                                                        </xsl:when>
                                                        <xsl:otherwise>
                                                            <xsl:text>Not constrained.</xsl:text>
                                                        </xsl:otherwise>
                                                    </xsl:choose>
                                                </div>
                                            </details>
                                        </span>
                                    </xsl:if>

                                </xsl:if>
                            </div>
                        </xsl:for-each>
                    </td>
                </xsl:otherwise>

            </xsl:choose>

        </tr>
    </xsl:template>

    <xsl:template
        match="part[@name = 'statement']"
        mode="statement">
        <xsl:param
            as="xs:boolean"
            name="tag-with-id"
            required="false"
            select="true()"
            tunnel="true" />
        <xsl:variable
            as="node()*"
            name="content">
            <div
                class="statement">
                <xsl:if
                    test="starts-with(root(.)/catalog/metadata/title, 'NIST Special Publication 800-53 Revision 5') and $tag-with-id">
                    <xsl:attribute
                        name="id"
                        select="@id" />
                </xsl:if>
                <xsl:apply-templates
                    mode="statement"
                    select="node()" />
            </div>
        </xsl:variable>
        <xsl:copy-of
            select="$content" />
    </xsl:template>

    <xsl:template
        match="part[@name = 'item']"
        mode="statement">
        <xsl:param
            as="xs:boolean"
            name="tag-with-id"
            required="false"
            select="true()"
            tunnel="true" />
        <div
            class="item">
            <xsl:if
                test="starts-with(root(.)/catalog/metadata/title, 'NIST Special Publication 800-53 Revision 5') and $tag-with-id">
                <xsl:attribute
                    name="id"
                    select="@id" />
            </xsl:if>
            <xsl:variable
                as="node()*"
                name="content">
                <xsl:apply-templates
                    mode="statement"
                    select="node()" />
            </xsl:variable>
            <xsl:copy-of
                select="$content" />
        </div>
    </xsl:template>

    <xsl:template
        match="p"
        mode="statement">
        <xsl:apply-templates
            mode="statement"
            select="node()" />
    </xsl:template>

    <xsl:template
        match="em | strong | ol | li | b"
        mode="statement">
        <xsl:element
            name="span">
            <xsl:attribute
                name="class">semantic-error</xsl:attribute>
            <xsl:attribute
                name="title">The input catalog contained a faux HTML &lt;{local-name()}&gt; element</xsl:attribute>
            <xsl:apply-templates
                mode="statement"
                select="node()" />
        </xsl:element>
    </xsl:template>

    <xsl:template
        match="a"
        mode="statement">
        <a
            href="{@href}">
            <xsl:value-of
                select="." />
        </a>
    </xsl:template>

    <xsl:template
        match="prop[@name = 'label']"
        mode="statement">
        <xsl:text>{@value} </xsl:text>
    </xsl:template>

    <!--<xsl:template
        match="insert"
        mode="statement">
        <span
            class="identifier">[{@id-ref}]</span>
    </xsl:template>-->

    <xsl:template
        match="insert"
        mode="statement">
        <xsl:param
            as="xs:boolean"
            name="tag-with-id"
            required="false"
            select="true()"
            tunnel="true" />
        <xsl:choose>
            <xsl:when
                test="@type = 'param'">
                <span>
                    <xsl:attribute
                        name="title"
                        select="@id-ref" />
                    <xsl:if
                        test="starts-with(root(.)/catalog/metadata/title, 'NIST Special Publication 800-53 Revision 5') and $tag-with-id">
                        <xsl:attribute
                            name="id"
                            select="@id-ref" />
                        <xsl:choose>
                            <xsl:when
                                test="fn:novel-ODP(@id-ref)">
                                <xsl:attribute
                                    name="class">novel-ODP insert</xsl:attribute>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:attribute
                                    name="class">established-ODP insert</xsl:attribute>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:if>
                    <xsl:if
                        test="$show-ODP-id">
                        <span
                            class="superscript-identifier">
                            <xsl:value-of
                                select="@id-ref" />
                        </span>
                    </xsl:if>
                    <xsl:variable
                        as="node()*"
                        name="insert">
                        <xsl:apply-templates
                            mode="statement"
                            select="ancestor::control/param[@id = current()/@id-ref]" />
                    </xsl:variable>
                    <xsl:choose>
                        <xsl:when
                            test="starts-with(root(.)/catalog/metadata/title, 'NIST Special Publication 800-53 Revision 4')">
                            <!-- show r4 ODPs -->
                            <!--<xsl:message select="$insert"/>-->
                            <!--<xsl:choose>
                                <xsl:when
                                    test="$show-tailored-ODPs">
                                    <details
                                        class="ODPs">
                                        <summary>
                                            <xsl:copy-of
                                                select="$insert" />
                                        </summary>
                                        <xsl:variable
                                            as="xs:string*"
                                            name="ODPs">
                                            <xsl:choose>
                                                <xsl:when
                                                    test="$ODP-low//set-parameter[@id-ref = current()/@id-ref]">
                                                    <xsl:text>Ⓛ: {$ODP-low//set-parameter[@id-ref = current()/@id-ref]/value}</xsl:text>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:text>Ⓛ: (Not defined)</xsl:text>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                            <xsl:choose>
                                                <xsl:when
                                                    test="$ODP-moderate//set-parameter[@id-ref = current()/@id-ref]">
                                                    <xsl:text>Ⓜ: {$ODP-moderate//set-parameter[@id-ref = current()/@id-ref]/value}</xsl:text>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:text>Ⓜ: (Not defined)</xsl:text>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                            <xsl:choose>
                                                <xsl:when
                                                    test="$ODP-high//set-parameter[@id-ref = current()/@id-ref]">
                                                    <xsl:text>Ⓗ: {$ODP-high//set-parameter[@id-ref = current()/@id-ref]/value}</xsl:text>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:text>Ⓗ: (Not defined)</xsl:text>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:variable>
                                        <xsl:for-each
                                            select="$ODPs">
                                            <xsl:if
                                                test="position() != 1">
                                                <br />
                                            </xsl:if>
                                            <xsl:copy-of
                                                select="." />
                                        </xsl:for-each>
                                    </details>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:copy-of
                                        select="$insert" />
                                </xsl:otherwise>
                            </xsl:choose>-->
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:copy-of
                                select="$insert" />
                        </xsl:otherwise>
                    </xsl:choose>
                </span>
            </xsl:when>
            <xsl:otherwise>
                <xsl:message
                    terminate="yes">Life must end</xsl:message>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template
        match="param"
        mode="statement">
        <xsl:apply-templates
            mode="statement" />
    </xsl:template>

    <xsl:template
        match="label"
        mode="statement">
        <xsl:text>[</xsl:text>
        <span
            class="label">
            <xsl:text>Assignment: </xsl:text>
            <xsl:value-of
                select="." />
        </span>
        <xsl:text>]</xsl:text>
    </xsl:template>

    <xsl:template
        match="select"
        mode="statement">
        <xsl:variable
            as="node()*"
            name="choices">
            <xsl:for-each
                select="choice">
                <xsl:choose>
                    <xsl:when
                        test="*">
                        <xsl:variable
                            as="node()*"
                            name="substrings">
                            <xsl:apply-templates
                                mode="statement"
                                select="node()" />
                        </xsl:variable>
                        <xsl:copy-of
                            select="$substrings" />
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of
                            select="." />
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </xsl:variable>
        <xsl:text>[</xsl:text>
        <span
            class="select">
            <xsl:choose>
                <xsl:when
                    test="@how-many = 'one or more'">
                    <xsl:text>Selection (one or more): </xsl:text>
                    <xsl:for-each
                        select="$choices">
                        <xsl:if
                            test="position() != 1">
                            <xsl:text>; </xsl:text>
                        </xsl:if>
                        <xsl:copy-of
                            select="." />
                    </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>Selection: </xsl:text>
                    <xsl:for-each
                        select="$choices">
                        <xsl:if
                            test="position() != 1">
                            <span
                                class="boolean"> or </span>
                        </xsl:if>
                        <xsl:copy-of
                            select="." />
                    </xsl:for-each>
                </xsl:otherwise>
            </xsl:choose>
        </span>
        <xsl:text>]</xsl:text>
    </xsl:template>

    <xsl:template
        match="remarks"
        mode="statement"><!-- ignore for now --></xsl:template>

    <xsl:template
        match="text()"
        mode="statement">
        <xsl:copy-of
            select="." />
    </xsl:template>

    <xsl:template
        match="node()"
        mode="statement"
        priority="-9">
        <xsl:message
            terminate="yes">control: {ancestor::control/@id} id: {@id} name: {name()}</xsl:message>
    </xsl:template>

</xsl:stylesheet>
