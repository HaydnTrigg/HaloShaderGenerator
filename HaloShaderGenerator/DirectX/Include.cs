using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.InteropServices;
using System.Text;
using System.Threading.Tasks;

namespace HaloShaderGenerator.DirectX
{
    public abstract class Include
    {
        [UnmanagedFunctionPointer(CallingConvention.StdCall)]
        private delegate int OpenCallBack(IntPtr thisPtr, D3D.INCLUDE_TYPE includeType, IntPtr fileNameRef, IntPtr pParentData, ref IntPtr dataRef, ref int bytesRef);

        [UnmanagedFunctionPointer(CallingConvention.StdCall)]
        private delegate int CloseCallBack(IntPtr thisPtr, IntPtr pData);

        public IntPtr NativePointer;
        private OpenCallBack _openCallback;
        private CloseCallBack _closeCallback;

        protected Dictionary<IntPtr, string> DirectoryMap = new Dictionary<IntPtr, string>();

        protected Include(string root_directory)
        {
            DirectoryMap[IntPtr.Zero] = root_directory;

            // Allocate object layout in memory 
            // - 1 pointer to VTBL table
            // - following that the VTBL itself - with 2 function pointers for Open and Close methods
            NativePointer = Marshal.AllocHGlobal(IntPtr.Size * 3);

            // Write pointer to vtbl
            IntPtr vtblPtr = IntPtr.Add(NativePointer, IntPtr.Size);
            Marshal.WriteIntPtr(NativePointer, vtblPtr);
            _openCallback = new OpenCallBack(Open);
            Marshal.WriteIntPtr(vtblPtr, Marshal.GetFunctionPointerForDelegate(_openCallback));
            _closeCallback = new CloseCallBack(Close);
            Marshal.WriteIntPtr(IntPtr.Add(vtblPtr, IntPtr.Size), Marshal.GetFunctionPointerForDelegate(_closeCallback));
        }

        private int Open(IntPtr thisPtr, D3D.INCLUDE_TYPE includeType, IntPtr pFileName, IntPtr pParentData, ref IntPtr ppData, ref int pBytes)
        {
            string result = null;
            string filepath = pFileName == IntPtr.Zero ? null : Marshal.PtrToStringAnsi(pFileName);
            string parent_directory = DirectoryMap[pParentData];
            //TODO Support non relative directories
            string this_directory = System.IO.Path.GetDirectoryName(System.IO.Path.Combine(parent_directory, filepath));
            int hresult = Open(includeType, filepath, parent_directory, ref result);

            if (hresult != 0)
            {
                return hresult;
            }

            if (result != null)
            {
                //NOTE: DON'T INCLUDE END BYTE!! byte[] data = Encoding.ASCII.GetBytes(result + char.MinValue);
                byte[] data = Encoding.ASCII.GetBytes(result);
                var ptr = Marshal.AllocHGlobal(data.Length);
                Marshal.Copy(data, 0, ptr, data.Length);

                ppData = ptr;
                pBytes = data.Length;

                DirectoryMap[ppData] = this_directory;
            }

            return hresult;
        }

        private int Close(IntPtr thisPtr, IntPtr pData)
        {
            return Close(pData);
        }

        protected abstract int Open(D3D.INCLUDE_TYPE includeType, string filename, string directory, ref string result);
        protected virtual int Close(IntPtr pData)
        {
            if (pData != IntPtr.Zero)
            {
                Marshal.FreeHGlobal(pData);
            }
            return 0;
        }
    }
}
