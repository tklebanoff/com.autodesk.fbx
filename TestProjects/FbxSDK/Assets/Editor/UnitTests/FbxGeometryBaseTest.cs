﻿// ***********************************************************************
// Copyright (c) 2017 Unity Technologies. All rights reserved.
//
// Licensed under the ##LICENSENAME##.
// See LICENSE.md file in the project root for full license information.
// ***********************************************************************

using NUnit.Framework;
using System.Collections;
using Autodesk.Fbx;

namespace Autodesk.Fbx.UnitTests
{
    public class FbxGeometryBaseTestBase<T> : FbxLayerContainerBase<T> where T : FbxGeometryBase
    {
        override public void TestBasics(T geometryBase, FbxNodeAttribute.EType typ)
        {
            base.TestBasics(geometryBase, typ);

            geometryBase.InitControlPoints (24);
            Assert.AreEqual (geometryBase.GetControlPointsCount (), 24);
            geometryBase.SetControlPointAt(new FbxVector4(1,2,3,4), 0);
            Assert.AreEqual(new FbxVector4(1,2,3,4), geometryBase.GetControlPointAt(0));

            int layerId0 = geometryBase.CreateLayer();
            int layerId1 = geometryBase.CreateLayer();
            var layer0 = geometryBase.GetLayer(layerId0);
            var layer1 = geometryBase.GetLayer(layerId1);
            Assert.AreNotEqual(layer0, layer1);

            // Fbx crashes setting a negative control point index, so we do some testing:
            Assert.That (() => geometryBase.SetControlPointAt (new FbxVector4(), -1), Throws.Exception.TypeOf<System.ArgumentOutOfRangeException>());

            // It doesn't crash with past-the-end, it resizes; make sure we don't block that.
            geometryBase.SetControlPointAt (new FbxVector4(1,2,3,4), 50); // does not throw
            Assert.AreEqual (geometryBase.GetControlPointsCount (), 51);

            // It doesn't crash getting negative nor past-the-end.
            // The vector returned is documented to be (0,0,0,1) but actually
            // seems to be (0,0,0,epsilon).
            geometryBase.GetControlPointAt(-1);
            geometryBase.GetControlPointAt(geometryBase.GetControlPointsCount() + 1);

            var elementNormal = geometryBase.CreateElementNormal ();
            Assert.IsInstanceOf<FbxLayerElementNormal> (elementNormal);

            var elementTangent = geometryBase.CreateElementTangent ();
            Assert.IsInstanceOf<FbxLayerElementTangent> (elementTangent);
        }
    }

    public class FbxGeometryBaseTest : FbxGeometryBaseTestBase<FbxGeometryBase> {
        [Test]
        public void TestBasics()
        {
            base.TestBasics(CreateObject("geometry base"), FbxNodeAttribute.EType.eUnknown);

            // You can even initialize to a negative number of control points:
            using (FbxGeometryBase geometryBase2 = CreateObject ("geometry base")) {
                // make sure this doesn't crash
                geometryBase2.InitControlPoints (-1);
            }
        }
    }

    public class FbxGeometryTestBase<T> : FbxGeometryBaseTestBase<T> where T : FbxGeometry
    {
        override public void TestBasics(T fbxGeometry, FbxNodeAttribute.EType typ)
        {
            base.TestBasics(fbxGeometry, typ);

            int origCount = fbxGeometry.GetDeformerCount ();

            // test get blendshape deformer
            FbxBlendShape blendShape = FbxBlendShape.Create (Manager, "blendShape");
            int index = fbxGeometry.AddDeformer (blendShape);
            Assert.GreaterOrEqual (index, 0);
            origCount++;

            // TODO: (UNI-19581): If we add the blendShape after the skin, then the below
            //                    tests fail.
            Assert.AreEqual (blendShape, fbxGeometry.GetBlendShapeDeformer (index));
            Assert.AreEqual (blendShape, fbxGeometry.GetBlendShapeDeformer (index, null));
            Assert.AreEqual (blendShape, fbxGeometry.GetDeformer (index, FbxDeformer.EDeformerType.eBlendShape));
            Assert.AreEqual (1, fbxGeometry.GetDeformerCount (FbxDeformer.EDeformerType.eBlendShape));

            // test add deformer
            FbxSkin skin = FbxSkin.Create (Manager, "skin");
            int skinIndex = fbxGeometry.AddDeformer (skin);
            Assert.GreaterOrEqual (skinIndex, 0);
            Assert.AreEqual(skin, fbxGeometry.GetDeformer(skinIndex));

            // test get invalid deformer index doesn't crash
            fbxGeometry.GetDeformer(-1, new FbxStatus());
            fbxGeometry.GetDeformer(int.MaxValue, new FbxStatus());

            // test get deformer null FbxStatus
            fbxGeometry.GetDeformer(0, null);

            // check right index but wrong type
            Assert.IsNull (fbxGeometry.GetDeformer (skinIndex, FbxDeformer.EDeformerType.eVertexCache, null));

            Assert.AreEqual (origCount+1, fbxGeometry.GetDeformerCount ());

            // test add null deformer
            Assert.That (() => fbxGeometry.AddDeformer(null), Throws.Exception.TypeOf<System.ArgumentNullException>());

            // test add invalid deformer
            skin.Destroy();
            Assert.That (() => fbxGeometry.AddDeformer(skin), Throws.Exception.TypeOf<System.ArgumentNullException>());
        }
    }

    public class FbxGeometryTest : FbxGeometryTestBase<FbxGeometry>
    {
        [Test]
        public void TestBasics()
        {
            base.TestBasics(CreateObject ("geometry"), FbxNodeAttribute.EType.eUnknown);
        }
    }

    public class FbxShapeTest : FbxGeometryBaseTestBase<FbxShape>
    {
        [Test]
        public void TestBasics()
        {
            base.TestBasics(CreateObject ("shape"), FbxNodeAttribute.EType.eShape);
        }
    }
}
