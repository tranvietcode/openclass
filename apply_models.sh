#!/bin/bash
cat << 'EOF' > models/role.js
'use strict';
const { Model } = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class Role extends Model {
    static associate(models) {
      Role.hasMany(models.User, { foreignKey: 'role_id' });
    }
  }
  Role.init({
    name: DataTypes.ENUM('admin', 'teacher', 'student')
  }, {
    sequelize,
    modelName: 'Role',
  });
  return Role;
};
EOF
cat << 'EOF' > models/user.js
'use strict';
const { Model } = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class User extends Model {
    static associate(models) {
      User.belongsTo(models.Role, { foreignKey: 'role_id' });
      User.hasMany(models.TeacherSubject, { foreignKey: 'teacher_id' });
      User.hasMany(models.Class, { foreignKey: 'teacher_id' });
      User.hasMany(models.Enrollment, { foreignKey: 'student_id' });
      User.hasMany(models.Blog, { foreignKey: 'teacher_id' });
      User.hasMany(models.QuizResult, { foreignKey: 'student_id' });
      User.hasMany(models.Rating, { foreignKey: 'student_id' });
    }
  }
  User.init({
    name: DataTypes.STRING,
    email: {
      type: DataTypes.STRING,
      unique: true
    },
    password: DataTypes.STRING,
    role_id: DataTypes.INTEGER,
    teacher_status: DataTypes.ENUM('pending', 'approved', 'rejected'),
    bio: DataTypes.TEXT
  }, {
    sequelize,
    modelName: 'User',
  });
  return User;
};
EOF
cat << 'EOF' > models/subject.js
'use strict';
const { Model } = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class Subject extends Model {
    static associate(models) {
      Subject.hasMany(models.TeacherSubject, { foreignKey: 'subject_id' });
      Subject.hasMany(models.Class, { foreignKey: 'subject_id' });
    }
  }
  Subject.init({
    name: {
      type: DataTypes.STRING,
      unique: true
    },
    description: DataTypes.TEXT
  }, {
    sequelize,
    modelName: 'Subject',
  });
  return Subject;
};
EOF
cat << 'EOF' > models/teachersubject.js
'use strict';
const { Model } = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class TeacherSubject extends Model {
    static associate(models) {
      TeacherSubject.belongsTo(models.User, { foreignKey: 'teacher_id' });
      TeacherSubject.belongsTo(models.Subject, { foreignKey: 'subject_id' });
    }
  }
  TeacherSubject.init({
    teacher_id: DataTypes.INTEGER,
    subject_id: DataTypes.INTEGER
  }, {
    sequelize,
    modelName: 'TeacherSubject',
  });
  return TeacherSubject;
};
EOF
cat << 'EOF' > models/class.js
'use strict';
const { Model } = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class Class extends Model {
    static associate(models) {
      Class.belongsTo(models.User, { foreignKey: 'teacher_id' });
      Class.belongsTo(models.Subject, { foreignKey: 'subject_id' });
      Class.hasMany(models.Enrollment, { foreignKey: 'class_id' });
      Class.hasMany(models.Material, { foreignKey: 'class_id' });
      Class.hasMany(models.Quiz, { foreignKey: 'class_id' });
      Class.hasMany(models.Rating, { foreignKey: 'class_id' });
    }
  }
  Class.init({
    title: DataTypes.STRING,
    description: DataTypes.TEXT,
    teacher_id: DataTypes.INTEGER,
    subject_id: DataTypes.INTEGER,
    average_rating: DataTypes.FLOAT
  }, {
    sequelize,
    modelName: 'Class',
  });
  return Class;
};
EOF
cat << 'EOF' > models/enrollment.js
'use strict';
const { Model } = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class Enrollment extends Model {
    static associate(models) {
      Enrollment.belongsTo(models.User, { foreignKey: 'student_id' });
      Enrollment.belongsTo(models.Class, { foreignKey: 'class_id' });
    }
  }
  Enrollment.init({
    student_id: DataTypes.INTEGER,
    class_id: DataTypes.INTEGER,
    enrolled_at: DataTypes.DATE
  }, {
    sequelize,
    modelName: 'Enrollment',
  });
  return Enrollment;
};
EOF
cat << 'EOF' > models/blog.js
'use strict';
const { Model } = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class Blog extends Model {
    static associate(models) {
      Blog.belongsTo(models.User, { foreignKey: 'teacher_id' });
    }
  }
  Blog.init({
    title: DataTypes.STRING,
    content: DataTypes.TEXT,
    teacher_id: DataTypes.INTEGER
  }, {
    sequelize,
    modelName: 'Blog',
  });
  return Blog;
};
EOF
cat << 'EOF' > models/material.js
'use strict';
const { Model } = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class Material extends Model {
    static associate(models) {
      Material.belongsTo(models.Class, { foreignKey: 'class_id' });
    }
  }
  Material.init({
    title: DataTypes.STRING,
    file_url: DataTypes.STRING,
    class_id: DataTypes.INTEGER
  }, {
    sequelize,
    modelName: 'Material',
  });
  return Material;
};
EOF
cat << 'EOF' > models/quiz.js
'use strict';
const { Model } = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class Quiz extends Model {
    static associate(models) {
      Quiz.belongsTo(models.Class, { foreignKey: 'class_id' });
      Quiz.hasMany(models.Question, { foreignKey: 'quiz_id' });
      Quiz.hasMany(models.QuizResult, { foreignKey: 'quiz_id' });
    }
  }
  Quiz.init({
    class_id: DataTypes.INTEGER,
    title: DataTypes.STRING
  }, {
    sequelize,
    modelName: 'Quiz',
  });
  return Quiz;
};
EOF
cat << 'EOF' > models/question.js
'use strict';
const { Model } = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class Question extends Model {
    static associate(models) {
      Question.belongsTo(models.Quiz, { foreignKey: 'quiz_id' });
      Question.hasMany(models.Answer, { foreignKey: 'question_id' });
    }
  }
  Question.init({
    quiz_id: DataTypes.INTEGER,
    question_text: DataTypes.TEXT
  }, {
    sequelize,
    modelName: 'Question',
  });
  return Question;
};
EOF
cat << 'EOF' > models/answer.js
'use strict';
const { Model } = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class Answer extends Model {
    static associate(models) {
      Answer.belongsTo(models.Question, { foreignKey: 'question_id' });
    }
  }
  Answer.init({
    question_id: DataTypes.INTEGER,
    answer_text: DataTypes.TEXT,
    is_correct: DataTypes.BOOLEAN
  }, {
    sequelize,
    modelName: 'Answer',
  });
  return Answer;
};
EOF
cat << 'EOF' > models/quizresult.js
'use strict';
const { Model } = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class QuizResult extends Model {
    static associate(models) {
      QuizResult.belongsTo(models.User, { foreignKey: 'student_id' });
      QuizResult.belongsTo(models.Quiz, { foreignKey: 'quiz_id' });
    }
  }
  QuizResult.init({
    student_id: DataTypes.INTEGER,
    quiz_id: DataTypes.INTEGER,
    score: DataTypes.FLOAT,
    completed_at: DataTypes.DATE
  }, {
    sequelize,
    modelName: 'QuizResult',
  });
  return QuizResult;
};
EOF
cat << 'EOF' > models/rating.js
'use strict';
const { Model } = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class Rating extends Model {
    static associate(models) {
      Rating.belongsTo(models.User, { foreignKey: 'student_id' });
      Rating.belongsTo(models.Class, { foreignKey: 'class_id' });
    }
  }
  Rating.init({
    student_id: DataTypes.INTEGER,
    class_id: DataTypes.INTEGER,
    stars: DataTypes.INTEGER,
    comment: DataTypes.TEXT
  }, {
    sequelize,
    modelName: 'Rating',
  });
  return Rating;
};
EOF
