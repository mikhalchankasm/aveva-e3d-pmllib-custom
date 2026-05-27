using System;
using System.Globalization;
using Aveva.Core.PMLNet;

namespace AvevaE3D.CustomTools.Copy
{
    [PMLNetCallable()]
    public class CopyTools
    {
        private const int MaxFullNameLength = 50;

        [PMLNetCallable()]
        public CopyTools()
        {
        }

        [PMLNetCallable()]
        public void Assign(CopyTools that)
        {
            // Stateless PMLNet object.
        }

        [PMLNetCallable()]
        public string Version()
        {
            return "0.1.0";
        }

        [PMLNetCallable()]
        public int MaxNameLength()
        {
            return MaxFullNameLength;
        }

        [PMLNetCallable()]
        public string IndexedPrefix(string prefixRoot, double copyIndex)
        {
            string root = NormalizePrefixRoot(prefixRoot);
            int index = NormalizeCopyIndex(copyIndex);

            if (index <= 1)
            {
                return root + "-";
            }

            return root + "-(" + index.ToString(CultureInfo.InvariantCulture) + ")-";
        }

        [PMLNetCallable()]
        public string BaseName(string sourceName)
        {
            string baseName = NormalizeName(sourceName);

            if (baseName.StartsWith("copyof-", StringComparison.OrdinalIgnoreCase))
            {
                return baseName.Substring(7);
            }

            if (baseName.StartsWith("copyof-(", StringComparison.OrdinalIgnoreCase))
            {
                int marker = baseName.IndexOf(")-", StringComparison.Ordinal);
                if (marker >= 0 && marker + 2 < baseName.Length)
                {
                    return baseName.Substring(marker + 2);
                }
            }

            return baseName;
        }

        [PMLNetCallable()]
        public string BuildName(string sourceName, string elementType, string prefixRoot, double copyIndex, string nameMode)
        {
            string prefix = IndexedPrefix(prefixRoot, copyIndex);
            string baseName = BaseName(sourceName);
            string mode = NormalizeMode(nameMode);
            string type = NormalizeType(elementType);
            string head;

            if (mode == "TYPEPREFIX")
            {
                head = prefix + type + "-";
            }
            else if (mode == "PIPEBRANCH")
            {
                if (type == "PIPE")
                {
                    head = prefix + "P-";
                }
                else if (type == "BRAN")
                {
                    head = prefix + "B-";
                }
                else
                {
                    head = prefix + type + "-";
                }
            }
            else if (mode == "LOWER")
            {
                head = prefix.ToLowerInvariant();
                baseName = baseName.ToLowerInvariant();
            }
            else
            {
                head = prefix;
            }

            return LimitedName(head, baseName);
        }

        [PMLNetCallable()]
        public bool IsWithinNameLimit(string fullName)
        {
            if (fullName == null)
            {
                return false;
            }

            return fullName.Length <= MaxFullNameLength;
        }

        private static string LimitedName(string head, string baseName)
        {
            if (head == null)
            {
                head = string.Empty;
            }

            if (baseName == null)
            {
                baseName = string.Empty;
            }

            int maxBaseLength = MaxFullNameLength - 1 - head.Length;
            if (maxBaseLength < 1)
            {
                return string.Empty;
            }

            if (baseName.Length > maxBaseLength)
            {
                baseName = baseName.Substring(0, maxBaseLength);
            }

            return "/" + head + baseName;
        }

        private static string NormalizeName(string sourceName)
        {
            if (string.IsNullOrEmpty(sourceName))
            {
                return string.Empty;
            }

            string value = sourceName.Trim();
            while (value.StartsWith("/", StringComparison.Ordinal))
            {
                value = value.Substring(1);
            }

            return value;
        }

        private static string NormalizePrefixRoot(string prefixRoot)
        {
            if (string.IsNullOrEmpty(prefixRoot))
            {
                return "copyof";
            }

            return prefixRoot.Trim().Trim('-');
        }

        private static int NormalizeCopyIndex(double copyIndex)
        {
            if (copyIndex < 1)
            {
                return 1;
            }

            return Convert.ToInt32(Math.Truncate(copyIndex));
        }

        private static string NormalizeMode(string nameMode)
        {
            if (string.IsNullOrEmpty(nameMode))
            {
                return "DEFAULT";
            }

            return nameMode.Trim().ToUpperInvariant();
        }

        private static string NormalizeType(string elementType)
        {
            if (string.IsNullOrEmpty(elementType))
            {
                return "ITEM";
            }

            return elementType.Trim().ToUpperInvariant();
        }
    }
}
