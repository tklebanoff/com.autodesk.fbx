// ***********************************************************************
// Copyright (c) 2017 Unity Technologies. All rights reserved.
//
// Licensed under the ##LICENSENAME##.
// See LICENSE.md file in the project root for full license information.
// ***********************************************************************
%module Globals
%{
#include "fbxsdk.h"
%}

/* helpers for defining equality correctly */
%include "equality.i"

// define typemaps for INOUT arguments
%include typemaps.i

/* 
 * Handle object lifetime in Fbx by adding indirection.
 *
 * Important: we need to declare all the weak-pointer classes here *before*
 * we %include them later. Otherwise e.g. FbxObject::GetScene won't wrap
 * up its scene. We do that by including weakpointerhandles.i
 *
 * Chicken-and-egg problem: weakpointerhandles.i is generated automatically by
 * running swig on this .i file. When we run swig on this .i file, we define
 * SWIG_GENERATING_TYPEDEFS to avoid including a file that hasn't been generated yet.
 */
%include "FbxSharpObjectLifetime.i"
#ifndef SWIG_GENERATING_TYPEDEFS
%include "weakpointerhandles.i"
#endif

/*
 * Do null-pointer checking when setting variables of struct/class type.
 * e.g. if we have a global
 *      struct time_t g_startTime;
 * setting it will raise an exception if we set it with a null pointer.
 */
%naturalvar;

/*
 * Do null-pointer checking when passing the 'this' pointer.
 */
%typemap(in, canthrow=1) SWIGTYPE *self
%{ if (!$input) {
    SWIG_CSharpSetPendingException(SWIG_CSharpNullReferenceException, "'this' is null ($1_basetype)");
    return $null;
  }
  $1 = ($1_ltype)$input; %}

/*
 * How to handle strings. Must be before the includes that actually include code.
 */
%include "fbxstring.i"

/*
 * How to handle certain types we've optimized so they can be blitted.
 */
%include "optimization.i"

%import "fbxsdk.h"
%import "fbxsdk/fbxsdk_def.h"
%import "fbxsdk/fbxsdk_nsbegin.h"
%import "fbxsdk/fbxsdk_nsend.h"
%import "fbxsdk/fbxsdk_version.h"
%import "fbxsdk/core/arch/fbxarch.h"
%import "fbxsdk/core/arch/fbxnew.h"

/* Parse the header file to generate wrappers */

/* For generating wrapper to export an empty scene */
#define DOXYGEN_SHOULD_SKIP_THIS           // skip code that is undocumented and subject to change without notice

%nodefaultdtor;                             // Disable creation of default constructors

/* Include all the code that uses templates here. It's important to include
 * them *before* the %ignore "" directive. */
%include "fbxtemplates.i"

#define IGNORE_ALL_INCLUDE_SOME

#ifdef IGNORE_ALL_INCLUDE_SOME
/* Ignore everything, and force the devs to allow certain items back in one by one.
 * Exception: don't force the devs to allow individual enum items in -- if we
 * allow the enum itself, all the values will come in. */
%ignore "";
%rename("%s", %$isenumitem) "";

#else                                       // Include everything but ignore some
%ignore __declspec(deprecated);             // Ignore deprecated anything
#endif

// porting: enable to exclude generation of wrappers
//#define EXCLUDE_ALL_INTERFACES

#ifndef EXCLUDE_ALL_INTERFACES
/* Core classes */
%include "fbxmath.i"
%include "fbxclassid.i"
%include "fbxmanager.i"
%include "fbxaxissystem.i"
%include "fbxsystemunit.i"

/* The emitter hierarchy. */
%include "fbxemitter.i"
%include "fbxobject.i"
%include "fbxcollection.i"
%include "fbxdocumentinfo.i"
%include "fbxdocument.i"
%include "fbxscene.i"
%include "fbxiobase.i"
%include "fbxexporter.i"
%include "fbximporter.i"
%include "fbxiosettings.i"
%include "fbxnode.i"
%include "fbxnodeattribute.i"
%include "fbxlayercontainer.i"
%include "fbxgeometrybase.i"
%include "fbxgeometry.i"
%include "fbxmesh.i"
%include "fbxglobalsettings.i"
%include "fbxpropertytypes.i"
%include "fbxskeleton.i"
#endif

/* Everything */
#ifdef FBXSDK_ALL_HEADERS
%include "fbxsdk/fbxsdk_version.h"
%include "fbxsdk/core/arch/fbxarch.h"
%include "fbxsdk/core/arch/fbxalloc.h"
%include "fbxsdk/core/arch/fbxdebug.h"
%include "fbxsdk/core/arch/fbxnew.h"
%include "fbxsdk/core/arch/fbxstdcompliant.h"
%include "fbxsdk/core/arch/fbxtypes.h"
%include "fbxsdk/core/base/fbxarray.h"
%include "fbxsdk/core/base/fbxbitset.h"
%include "fbxsdk/core/base/fbxcharptrset.h"
%include "fbxsdk/core/base/fbxcontainerallocators.h"
%include "fbxsdk/core/base/fbxdynamicarray.h"
%include "fbxsdk/core/base/fbxfile.h"
%include "fbxsdk/core/base/fbxfolder.h"
%include "fbxsdk/core/base/fbxhashmap.h"
%include "fbxsdk/core/base/fbxintrusivelist.h"
%include "fbxsdk/core/base/fbxmap.h"
%include "fbxsdk/core/base/fbxmemorypool.h"
%include "fbxsdk/core/base/fbxmultimap.h"
%include "fbxsdk/core/base/fbxpair.h"
%include "fbxsdk/core/base/fbxredblacktree.h"
%include "fbxsdk/core/base/fbxset.h"
%include "fbxsdk/core/base/fbxstatus.h"
%include "fbxsdk/core/base/fbxstring.h"
%include "fbxsdk/core/base/fbxstringlist.h"
%include "fbxsdk/core/base/fbxtime.h"
%include "fbxsdk/core/base/fbxtimecode.h"
%include "fbxsdk/core/base/fbxutils.h"
%include "fbxsdk/core/fbxclassid.h"
%include "fbxsdk/core/fbxconnectionpoint.h"
%include "fbxsdk/core/fbxdatatypes.h"
%include "fbxsdk/core/fbxemitter.h"
%include "fbxsdk/core/fbxevent.h"
%include "fbxsdk/core/fbxeventhandler.h"
%include "fbxsdk/core/fbxlistener.h"
%include "fbxsdk/core/fbxloadingstrategy.h"
%include "fbxsdk/core/fbxmanager.h"
%include "fbxsdk/core/fbxmodule.h"
%include "fbxsdk/core/fbxobject.h"
%include "fbxsdk/core/fbxperipheral.h"
%include "fbxsdk/core/fbxplugin.h"
%include "fbxsdk/core/fbxplugincontainer.h"
%include "fbxsdk/core/fbxproperty.h"
%include "fbxsdk/core/fbxpropertydef.h"
%include "fbxsdk/core/fbxpropertyhandle.h"
%include "fbxsdk/core/fbxpropertypage.h"
%include "fbxsdk/core/fbxpropertytypes.h"
%include "fbxsdk/core/fbxquery.h"
%include "fbxsdk/core/fbxqueryevent.h"
%include "fbxsdk/core/fbxscopedloadingdirectory.h"
%include "fbxsdk/core/fbxscopedloadingfilename.h"
%include "fbxsdk/core/fbxstream.h"
%include "fbxsdk/core/fbxsymbol.h"
%include "fbxsdk/core/fbxsystemunit.h"
%include "fbxsdk/core/fbxxref.h"
%include "fbxsdk/core/math/fbxaffinematrix.h"
%include "fbxsdk/core/math/fbxdualquaternion.h"
%include "fbxsdk/core/math/fbxmath.h"
%include "fbxsdk/core/math/fbxmatrix.h"
%include "fbxsdk/core/math/fbxquaternion.h"
%include "fbxsdk/core/math/fbxtransforms.h"
%include "fbxsdk/core/math/fbxvector2.h"
%include "fbxsdk/core/math/fbxvector4.h"
%include "fbxsdk/core/sync/fbxatomic.h"
%include "fbxsdk/core/sync/fbxclock.h"
%include "fbxsdk/core/sync/fbxsync.h"
%include "fbxsdk/core/sync/fbxthread.h"
%include "fbxsdk/fileio/collada/fbxcolladaanimationelement.h"
%include "fbxsdk/fileio/collada/fbxcolladaelement.h"
%include "fbxsdk/fileio/collada/fbxcolladaiostream.h"
%include "fbxsdk/fileio/collada/fbxcolladanamespace.h"
%include "fbxsdk/fileio/collada/fbxcolladatokens.h"
%include "fbxsdk/fileio/collada/fbxcolladautils.h"
%include "fbxsdk/fileio/collada/fbxreadercollada14.h"
%include "fbxsdk/fileio/collada/fbxwritercollada14.h"
%include "fbxsdk/fileio/fbx/fbxio.h"
%include "fbxsdk/fileio/fbx/fbxreaderfbx5.h"
%include "fbxsdk/fileio/fbx/fbxreaderfbx6.h"
%include "fbxsdk/fileio/fbx/fbxreaderfbx7.h"
%include "fbxsdk/fileio/fbx/fbxwriterfbx5.h"
%include "fbxsdk/fileio/fbx/fbxwriterfbx6.h"
%include "fbxsdk/fileio/fbx/fbxwriterfbx7.h"
%include "fbxsdk/fileio/fbxbase64coder.h"
%include "fbxsdk/fileio/fbxexporter.h"
%include "fbxsdk/fileio/fbxexternaldocreflistener.h"
%include "fbxsdk/fileio/fbxfiletokens.h"
%include "fbxsdk/fileio/fbxglobalcamerasettings.h"
%include "fbxsdk/fileio/fbxgloballightsettings.h"
%include "fbxsdk/fileio/fbxglobalsettings.h"
%include "fbxsdk/fileio/fbxgobo.h"
%include "fbxsdk/fileio/fbximporter.h"
%include "fbxsdk/fileio/fbxiobase.h"
%include "fbxsdk/fileio/fbxiopluginregistry.h"
%include "fbxsdk/fileio/fbxiosettings.h"
%include "fbxsdk/fileio/fbxiosettingspath.h"
%include "fbxsdk/fileio/fbxprogress.h"
%include "fbxsdk/fileio/fbxreader.h"
%include "fbxsdk/fileio/fbxstatistics.h"
%include "fbxsdk/fileio/fbxstatisticsfbx.h"
%include "fbxsdk/fileio/fbxwriter.h"
%include "fbxsdk/scene/animation/fbxanimcurve.h"
%include "fbxsdk/scene/animation/fbxanimcurvebase.h"
%include "fbxsdk/scene/animation/fbxanimcurvefilters.h"
%include "fbxsdk/scene/animation/fbxanimcurvenode.h"
%include "fbxsdk/scene/animation/fbxanimevalclassic.h"
%include "fbxsdk/scene/animation/fbxanimevalstate.h"
%include "fbxsdk/scene/animation/fbxanimevaluator.h"
%include "fbxsdk/scene/animation/fbxanimlayer.h"
%include "fbxsdk/scene/animation/fbxanimstack.h"
%include "fbxsdk/scene/animation/fbxanimutilities.h"
%include "fbxsdk/scene/constraint/fbxcharacter.h"
%include "fbxsdk/scene/constraint/fbxcharacternodename.h"
%include "fbxsdk/scene/constraint/fbxcharacterpose.h"
%include "fbxsdk/scene/constraint/fbxconstraint.h"
%include "fbxsdk/scene/constraint/fbxconstraintaim.h"
%include "fbxsdk/scene/constraint/fbxconstraintcustom.h"
%include "fbxsdk/scene/constraint/fbxconstraintparent.h"
%include "fbxsdk/scene/constraint/fbxconstraintposition.h"
%include "fbxsdk/scene/constraint/fbxconstraintrotation.h"
%include "fbxsdk/scene/constraint/fbxconstraintscale.h"
%include "fbxsdk/scene/constraint/fbxconstraintsinglechainik.h"
%include "fbxsdk/scene/constraint/fbxconstraintutils.h"
%include "fbxsdk/scene/constraint/fbxcontrolset.h"
%include "fbxsdk/scene/constraint/fbxhik2fbxcharacter.h"
%include "fbxsdk/scene/fbxaxissystem.h"
%include "fbxsdk/scene/fbxcollection.h"
%include "fbxsdk/scene/fbxcollectionexclusive.h"
%include "fbxsdk/scene/fbxcontainer.h"
%include "fbxsdk/scene/fbxcontainertemplate.h"
%include "fbxsdk/scene/fbxdisplaylayer.h"
%include "fbxsdk/scene/fbxdocument.h"
%include "fbxsdk/scene/fbxdocumentinfo.h"
%include "fbxsdk/scene/fbxenvironment.h"
%include "fbxsdk/scene/fbxgroupname.h"
%include "fbxsdk/scene/fbxlibrary.h"
%include "fbxsdk/scene/fbxobjectfilter.h"
%include "fbxsdk/scene/fbxobjectmetadata.h"
%include "fbxsdk/scene/fbxobjectscontainer.h"
%include "fbxsdk/scene/fbxpose.h"
%include "fbxsdk/scene/fbxreference.h"
%include "fbxsdk/scene/fbxscene.h"
%include "fbxsdk/scene/fbxselectionnode.h"
%include "fbxsdk/scene/fbxselectionset.h"
%include "fbxsdk/scene/fbxtakeinfo.h"
%include "fbxsdk/scene/fbxthumbnail.h"
%include "fbxsdk/scene/fbxvideo.h"
%include "fbxsdk/scene/geometry/fbxblendshape.h"
%include "fbxsdk/scene/geometry/fbxblendshapechannel.h"
%include "fbxsdk/scene/geometry/fbxcache.h"
%include "fbxsdk/scene/geometry/fbxcachedeffect.h"
%include "fbxsdk/scene/geometry/fbxcamera.h"
%include "fbxsdk/scene/geometry/fbxcamerastereo.h"
%include "fbxsdk/scene/geometry/fbxcameraswitcher.h"
%include "fbxsdk/scene/geometry/fbxcluster.h"
%include "fbxsdk/scene/geometry/fbxdeformer.h"
%include "fbxsdk/scene/geometry/fbxgenericnode.h"
%include "fbxsdk/scene/geometry/fbxgeometry.h"
%include "fbxsdk/scene/geometry/fbxgeometrybase.h"
%include "fbxsdk/scene/geometry/fbxgeometryweightedmap.h"
%include "fbxsdk/scene/geometry/fbxlayer.h"
%include "fbxsdk/scene/geometry/fbxlayercontainer.h"
%include "fbxsdk/scene/geometry/fbxlight.h"
%include "fbxsdk/scene/geometry/fbxlimitsutilities.h"
%include "fbxsdk/scene/geometry/fbxline.h"
%include "fbxsdk/scene/geometry/fbxlodgroup.h"
%include "fbxsdk/scene/geometry/fbxmarker.h"
%include "fbxsdk/scene/geometry/fbxmesh.h"
%include "fbxsdk/scene/geometry/fbxnode.h"
%include "fbxsdk/scene/geometry/fbxnodeattribute.h"
%include "fbxsdk/scene/geometry/fbxnull.h"
%include "fbxsdk/scene/geometry/fbxnurbs.h"
%include "fbxsdk/scene/geometry/fbxnurbscurve.h"
%include "fbxsdk/scene/geometry/fbxnurbssurface.h"
%include "fbxsdk/scene/geometry/fbxopticalreference.h"
%include "fbxsdk/scene/geometry/fbxpatch.h"
%include "fbxsdk/scene/geometry/fbxproceduralgeometry.h"
%include "fbxsdk/scene/geometry/fbxshape.h"
%include "fbxsdk/scene/geometry/fbxskeleton.h"
%include "fbxsdk/scene/geometry/fbxskin.h"
%include "fbxsdk/scene/geometry/fbxsubdeformer.h"
%include "fbxsdk/scene/geometry/fbxsubdiv.h"
%include "fbxsdk/scene/geometry/fbxtrimnurbssurface.h"
%include "fbxsdk/scene/geometry/fbxvertexcachedeformer.h"
%include "fbxsdk/scene/geometry/fbxweightedmapping.h"
%include "fbxsdk/scene/shading/fbxbindingoperator.h"
%include "fbxsdk/scene/shading/fbxbindingsentryview.h"
%include "fbxsdk/scene/shading/fbxbindingtable.h"
%include "fbxsdk/scene/shading/fbxbindingtablebase.h"
%include "fbxsdk/scene/shading/fbxbindingtableentry.h"
%include "fbxsdk/scene/shading/fbxconstantentryview.h"
%include "fbxsdk/scene/shading/fbxentryview.h"
%include "fbxsdk/scene/shading/fbxfiletexture.h"
%include "fbxsdk/scene/shading/fbximplementation.h"
%include "fbxsdk/scene/shading/fbximplementationfilter.h"
%include "fbxsdk/scene/shading/fbximplementationutils.h"
%include "fbxsdk/scene/shading/fbxlayeredtexture.h"
%include "fbxsdk/scene/shading/fbxlayerentryview.h"
%include "fbxsdk/scene/shading/fbxoperatorentryview.h"
%include "fbxsdk/scene/shading/fbxproceduraltexture.h"
%include "fbxsdk/scene/shading/fbxpropertyentryview.h"
%include "fbxsdk/scene/shading/fbxsemanticentryview.h"
%include "fbxsdk/scene/shading/fbxshadingconventions.h"
%include "fbxsdk/scene/shading/fbxsurfacelambert.h"
%include "fbxsdk/scene/shading/fbxsurfacematerial.h"
%include "fbxsdk/scene/shading/fbxsurfacephong.h"
%include "fbxsdk/scene/shading/fbxtexture.h"
%include "fbxsdk/utils/fbxclonemanager.h"
%include "fbxsdk/utils/fbxdeformationsevaluator.h"
%include "fbxsdk/utils/fbxembeddedfilesaccumulator.h"
%include "fbxsdk/utils/fbxgeometryconverter.h"
%include "fbxsdk/utils/fbxmanipulators.h"
%include "fbxsdk/utils/fbxmaterialconverter.h"
%include "fbxsdk/utils/fbxnamehandler.h"
%include "fbxsdk/utils/fbxprocessor.h"
%include "fbxsdk/utils/fbxprocessorshaderdependency.h"
%include "fbxsdk/utils/fbxprocessorxref.h"
%include "fbxsdk/utils/fbxprocessorxrefuserlib.h"
%include "fbxsdk/utils/fbxrenamingstrategy.h"
%include "fbxsdk/utils/fbxrenamingstrategybase.h"
%include "fbxsdk/utils/fbxrenamingstrategyfbx5.h"
%include "fbxsdk/utils/fbxrenamingstrategyfbx6.h"
%include "fbxsdk/utils/fbxrenamingstrategyfbx7.h"
%include "fbxsdk/utils/fbxrenamingstrategyutilities.h"
%include "fbxsdk/utils/fbxrootnodeutility.h"
%include "fbxsdk/utils/fbxusernotification.h"
#endif
