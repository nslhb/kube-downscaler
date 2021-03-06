from pykube.objects import NamespacedAPIObject
from pykube.objects import ReplicatedMixin
from pykube.objects import ScalableMixin


class Rollout(NamespacedAPIObject, ReplicatedMixin, ScalableMixin):

    version = "argoproj.io/v1alpha1"
    endpoint = "rollouts"
    kind = "Rollout"
