import qbs
import qbs.Probes as Probes

Project
{
    qbsSearchPaths: "qbs"
    references: [
            "core/src/src.qbs",
            "src/src.qbs"
    ]
}
