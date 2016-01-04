#            NimYAML - YAML implementation in Nim
#        (c) Copyright 2015 Felix Krause
#
#    See the file "copying.txt", included in this
#    distribution, for details about the copyright.

proc initTagLibrary*(): YamlTagLibrary =
    result.tags = initTable[string, TagId]()
    result.nextCustomTagId = yFirstCustomTagId
    result.secondaryPrefix = yamlTagRepositoryPrefix

proc registerUri*(tagLib: var YamlTagLibrary, uri: string): TagId =
    tagLib.tags[uri] = tagLib.nextCustomTagId
    result = tagLib.nextCustomTagId
    tagLib.nextCustomTagId = cast[TagId](cast[int](tagLib.nextCustomTagId) + 1)
    
proc uri*(tagLib: YamlTagLibrary, id: TagId): string =
    for iUri, iId in tagLib.tags.pairs:
        if iId == id:
            return iUri
    raise newException(KeyError, "Unknown tag id: " & $id)

proc failsafeTagLibrary*(): YamlTagLibrary =
    result = initTagLibrary()
    result.tags["!"] = yTagExclamationMark
    result.tags["?"] = yTagQuestionMark
    result.tags["tag:yaml.org,2002:str"] = yTagString
    result.tags["tag:yaml.org,2002:seq"] = yTagSequence
    result.tags["tag:yaml.org,2002:map"] = yTagMap

proc coreTagLibrary*(): YamlTagLibrary =
    result = failsafeTagLibrary()
    result.tags["tag:yaml.org,2002:null"]  = yTagNull
    result.tags["tag:yaml.org,2002:bool"]  = yTagBoolean
    result.tags["tag:yaml.org,2002:int"]   = yTagInteger
    result.tags["tag:yaml.org,2002:float"] = yTagFloat

proc extendedTagLibrary*(): YamlTagLibrary =
    result = coreTagLibrary()
    result.tags["tag:yaml.org,2002:omap"]      = yTagOrderedMap
    result.tags["tag:yaml.org,2002:pairs"]     = yTagPairs
    result.tags["tag:yaml.org,2002:binary"]    = yTagBinary
    result.tags["tag:yaml.org,2002:merge"]     = yTagMerge
    result.tags["tag:yaml.org,2002:timestamp"] = yTagTimestamp
    result.tags["tag:yaml.org,2002:value"]     = yTagValue
    result.tags["tag:yaml.org,2002:yaml"]      = yTagYaml
